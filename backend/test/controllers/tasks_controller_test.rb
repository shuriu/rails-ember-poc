require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user   = create(:user_with_boards, boards_count: 1, columns_count: 1, tasks_count: 2)
    @board  = @user.boards.first
    @column = @user.columns.first
    @task   = @user.tasks.first
  end

  test 'resource routes are authenticated' do
    get tasks_url
    assert_response :unauthorized

    get task_url(@task.id)
    assert_response :unauthorized

    post tasks_url
    assert_response :unauthorized

    put task_url(@task.id)
    assert_response :unauthorized

    delete task_url(@task.id)
    assert_response :unauthorized
  end

  test 'tasks belong to a specific user' do
    other_task = create(:task)

    get tasks_url, headers: jsonapi_headers(@user.token)
    task_ids = JSON.parse(response.body)['data'].map { |b| b['id'] }
    refute task_ids.include?(other_task.id.to_s), 'cannot GET other tasks'

    get task_url(other_task.id), headers: jsonapi_headers(@user.token)
    assert_response :not_found, 'cannot GET other task'

    new_task = build(:task)
    post tasks_url, headers: jsonapi_headers(@user.token),
      params: jsonapi_params(new_task, title: new_task.title, column_id: other_task.column_id)
    assert_response :forbidden, 'cannot CREATE task in other board'

    put task_url(other_task.id), headers: jsonapi_headers(@user.token), params: jsonapi_params(@task, title: 'Something Else')
    assert_response :not_found, 'cannot PUT other task'

    delete task_url(other_task.id), headers: jsonapi_headers(@user.token)
    assert_response :not_found, 'cannot DELETE other task'
  end

  test "GET /tasks" do
    get tasks_url, headers: jsonapi_headers(@user.token)
    assert_response :success
    assert_valid_schema :tasks
    assert_equal 2, JSON.parse(response.body)['data'].size
  end

  test "GET /tasks/:id" do
    get task_url(@task.id), headers: jsonapi_headers(@user.token)
    assert_response :success
    assert_valid_schema :task
  end

  test "GET /tasks/:id including relationships" do
    get task_url(@task.id), headers: jsonapi_headers(@user.token), params: { include: 'column' }
    assert_response :success
    assert_valid_schema :task
  end

  test "GET /tasks/:id with nonexistent id" do
    get task_url(666), headers: jsonapi_headers(@user.token)
    assert_response :not_found
    assert_valid_schema :errors
  end

  test "POST /tasks with valid attributes" do
    task = build(:task)
    post tasks_url, headers: jsonapi_headers(@user.token), params: jsonapi_params(task, title: task.title, column_id: @column.id)
    assert_response :success
    assert_valid_schema :task
  end

  test "POST /tasks with invalid attributes" do
    post tasks_url, headers: jsonapi_headers(@user.token), params: jsonapi_params(@task, title: '', column_id: @column.id)
    assert_response :unprocessable_entity
    assert_valid_schema :errors
  end

  test "POST /tasks without attributes" do
    task = build(:task)
    post tasks_url, headers: jsonapi_headers(@user.token), params: { _jsonapi: { data: {} } }.to_json
    assert_response :bad_request
    assert_valid_schema :errors
  end

  test "PATCH /tasks/:id with valid attributes" do
    put task_url(@task.id), headers: jsonapi_headers(@user.token), params: jsonapi_params(@task, title: 'Something Else')
    assert_response :success
    assert @user.tasks.where(title: 'Something Else').exists?, 'task has new title'
  end

  test "DELETE /tasks/:id" do
    delete task_url(@task.id), headers: jsonapi_headers(@user.token)
    assert_response :success
    assert_equal 1, @user.tasks.count, 'task was deleted'
  end
end
