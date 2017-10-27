require 'test_helper'

class ColumnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user   = create(:user_with_boards, boards_count: 1, columns_count: 2, tasks_count: 1)
    @board  = @user.boards.first
    @column = @board.columns.first
  end

  test 'resource routes are authenticated' do
    column = create(:column)

    get columns_url
    assert_response :unauthorized

    get column_url(column.id)
    assert_response :unauthorized

    post columns_url
    assert_response :unauthorized

    put column_url(column.id)
    assert_response :unauthorized

    delete column_url(column.id)
    assert_response :unauthorized
  end

  test 'columns belong to a specific user' do
    other_column = create(:column)

    get columns_url, headers: jsonapi_headers(@user.token)
    column_ids = JSON.parse(response.body)['data'].map { |b| b['id'] }
    refute column_ids.include?(other_column.id.to_s), 'cannot GET other columns'

    get column_url(other_column.id), headers: jsonapi_headers(@user.token)
    assert_response :not_found, 'cannot GET other column'

    new_column = build(:column)
    post columns_url, headers: jsonapi_headers(@user.token),
      params: jsonapi_params(new_column, title: new_column.title, board_id: other_column.board_id)
    assert_response :forbidden, 'cannot CREATE column in other board'

    put column_url(other_column.id), headers: jsonapi_headers(@user.token), params: jsonapi_params(@column, title: 'Something Else')
    assert_response :not_found, 'cannot PUT other column'

    delete column_url(other_column.id), headers: jsonapi_headers(@user.token)
    assert_response :not_found, 'cannot DELETE other column'
  end

  test "GET /columns" do
    get columns_url, headers: jsonapi_headers(@user.token)
    assert_response :success
    assert_valid_schema :columns
    assert_equal 2, JSON.parse(response.body)['data'].size
  end

  test "GET /columns/:id" do
    get column_url(@column.id), headers: jsonapi_headers(@user.token)
    assert_response :success
    assert_valid_schema :column
  end

  test "GET /columns/:id including relationships" do
    get column_url(@column.id), headers: jsonapi_headers(@user.token), params: { include: 'board,tasks' }
    assert_response :success
    assert_valid_schema :column
    with_parsed_body do |body|
      assert body['included'].detect { |o| o['type'] == 'boards' }, 'board is included'
      assert body['included'].detect { |o| o['type'] == 'tasks' }, 'tasks are included'
    end
  end

  test "GET /columns/:id with nonexistent id" do
    get column_url(666), headers: jsonapi_headers(@user.token)
    assert_response :not_found
    assert_valid_schema :errors
  end

  test "POST /columns with valid attributes" do
    column = build(:column)
    post columns_url, headers: jsonapi_headers(@user.token), params: jsonapi_params(column, title: column.title, board_id: @board.id)
    assert_response :success
    assert_valid_schema :column
  end

  test "POST /columns with invalid attributes" do
    post columns_url, headers: jsonapi_headers(@user.token), params: jsonapi_params(@column, title: '', board_id: @board.id)
    assert_response :unprocessable_entity
    assert_valid_schema :errors
  end

  test "POST /columns without attributes" do
    column = build(:column)
    post columns_url, headers: jsonapi_headers(@user.token), params: { _jsonapi: { data: {} } }.to_json
    assert_response :bad_request
    assert_valid_schema :errors
  end

  test "PATCH /columns/:id with valid attributes" do
    put column_url(@column.id), headers: jsonapi_headers(@user.token), params: jsonapi_params(@column, title: 'Something Else')
    assert_response :success
    assert @user.columns.where(title: 'Something Else').exists?, 'column has new title'
  end

  test "DELETE /columns/:id" do
    delete column_url(@column.id), headers: jsonapi_headers(@user.token)
    assert_response :success
    assert_equal 1, @user.columns.count, 'column was deleted'
  end
end
