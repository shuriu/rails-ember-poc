require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test 'GET /user/:id is authorized' do
    get user_path(@user.id)
    assert_response :unauthorized
  end

  test 'GET /users/:id' do
    get user_path(@user.id), headers: jsonapi_headers(@user.token)
    assert_response :success
    assert_valid_schema :user
  end

  test 'GET /users/:id with nonexistent id' do
    get user_path(666), headers: jsonapi_headers(@user.token)
    assert_response :not_found
  end

  test 'GET /users/current' do
    get current_users_path, headers: jsonapi_headers(@user.token)
    assert_response :success
    assert_valid_schema :user
  end
end
