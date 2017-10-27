require 'test_helper'

class BoardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user_with_boards, boards_count: 2, columns_count: 1, tasks_count: 1)
    @board = @user.boards.first
  end

  test 'resource routes are authenticated' do
    get boards_url
    assert_response :unauthorized

    get board_url(@board.id)
    assert_response :unauthorized

    post boards_url
    assert_response :unauthorized

    put board_url(@board.id)
    assert_response :unauthorized

    delete board_url(@board.id)
    assert_response :unauthorized
  end

  test 'boards belong to a specific user' do
    other_board = create(:board)

    get boards_url, headers: jsonapi_headers(@user.token)
    board_ids = JSON.parse(response.body)['data'].map { |b| b['id'] }
    refute board_ids.include?(other_board.id.to_s), 'cannot GET other boards'

    get board_url(other_board.id), headers: jsonapi_headers(@user.token)
    assert_response :not_found, 'cannot GET other board'

    new_board = build(:board)
    post boards_url, headers: jsonapi_headers(@user.token), params: jsonapi_params(new_board, title: new_board.title)
    assert @user.boards.where(title: new_board.title).exists?, 'board created for user'

    put board_url(other_board.id), headers: jsonapi_headers(@user.token), params: jsonapi_params(@board, title: 'Something Else')
    assert_response :not_found, 'cannot PUT other board'

    delete board_url(other_board.id), headers: jsonapi_headers(@user.token)
    assert_response :not_found, 'cannot DELETE other board'
  end

  test "GET /boards" do
    get boards_url, headers: jsonapi_headers(@user.token)
    assert_response :success
    assert_valid_schema :boards
  end

  test "GET /boards/:id" do
    get board_url(@board.id), headers: jsonapi_headers(@user.token)
    assert_response :success
    assert_valid_schema :board
  end

  test "GET /boards/:id including relationships" do
    get board_url(@board.id), headers: jsonapi_headers(@user.token), params: { include: 'user,columns,columns.tasks' }
    assert_response :success
    assert_valid_schema :board
    with_parsed_body do |body|
      assert body['included'].detect { |o| o['type'] == 'users' }, 'user is included'
      assert body['included'].detect { |o| o['type'] == 'columns' }, 'columns are included'
      assert body['included'].detect { |o| o['type'] == 'tasks' }, 'tasks are included'
    end
  end

  test "GET /boards/:id with nonexistent id" do
    get board_url(666), headers: jsonapi_headers(@user.token)
    assert_response :not_found
    assert_valid_schema :errors
  end

  test "GET /boards/:id with another user board id" do
    other_board = create(:board)

    get board_url(other_board.id), headers: jsonapi_headers(@user.token)
    assert_response :not_found
    assert_valid_schema :errors
  end

  test "POST /boards with valid attributes" do
    board = build(:board)
    post boards_url, headers: jsonapi_headers(@user.token), params: jsonapi_params(board, title: board.title)
    assert_response :success
    assert_valid_schema :board
  end

  test "POST /boards with invalid attributes" do
    board = build(:board)
    post boards_url, headers: jsonapi_headers(@user.token), params: jsonapi_params(board, title: '')
    assert_response :unprocessable_entity
    assert_valid_schema :errors
  end

  test "POST /boards without attributes" do
    board = build(:board)
    post boards_url, headers: jsonapi_headers(@user.token), params: { _jsonapi: { data: {} } }.to_json
    assert_response :bad_request
    assert_valid_schema :errors
  end

  test "PATCH /boards/:id with valid attributes" do
    put board_url(@board.id), headers: jsonapi_headers(@user.token), params: jsonapi_params(@board, title: 'Something Else')
    assert_response :success
    assert @user.boards.where(title: 'Something Else').exists?, 'board has new title'
  end

  test "DELETE /boards/:id" do
    delete board_url(@board.id), headers: jsonapi_headers(@user.token)
    assert_response :success
    assert_equal 1, @user.boards.count, 'board was deleted'
  end
end
