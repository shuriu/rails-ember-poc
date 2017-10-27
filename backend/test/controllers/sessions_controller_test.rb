require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test 'POST /sessions is not authenticated' do
    post sessions_url, headers: { 'CONTENT_TYPE': 'application/json' }, params: {
      session: { foo: :bar }
    }.to_json

    assert_response :unauthorized
    assert_valid_schema :errors

    assert_match /missing or incorrect/i, JSON.parse(response.body)['errors'].first['detail']
  end

  test 'POST /sessions returns 401 when email is not found' do
    post sessions_url, headers: { 'CONTENT_TYPE': 'application/json' }, params: {
      session: { email: 'nonexistent', password: 'password' }
    }.to_json

    assert_response :unauthorized
    assert_valid_schema :errors

    assert_match /missing or incorrect/i, JSON.parse(response.body)['errors'].first['detail']
  end

  test 'POST /sessions returns 401 when password is not correct' do
    post sessions_url, headers: { 'CONTENT_TYPE': 'application/json' }, params: {
      session: { email: @user.email, password: 'wrong' }
    }.to_json

    assert_response :unauthorized
    assert_valid_schema :errors

    assert_match /missing or incorrect/i, JSON.parse(response.body)['errors'].first['detail']
  end

  test 'POST /sessions returns the user token' do
    post sessions_url, headers: { 'CONTENT_TYPE': 'application/json' }, params: {
      session: { email: @user.email, password: 'password' }
    }.to_json

    assert_response :success
    assert_equal @user.token, JSON.parse(response.body)['token']
  end

  test 'DELETE /sessions is authenticated' do
    delete sessions_url
    assert_response :unauthorized
    assert_valid_schema :errors
  end

  test 'DELETE /sessions refreshes the user token' do
    initial_token = @user.token
    delete sessions_url, headers: jsonapi_headers(@user.token)

    assert_response :success
    @user.reload
    refute_equal initial_token, @user.token, 'tokens were changed'
  end
end
