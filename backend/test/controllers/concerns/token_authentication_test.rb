require 'test_helper'

module Concerns
  class TokenAuthenticationTest < ActionDispatch::IntegrationTest
    setup do
      Rails.application.routes.draw do
        controller :token_authentication do
          get :unauthenticated
          get :unauthenticated_checking_current_user
          get :authenticated
        end
      end
    end

    teardown do
      Rails.application.reload_routes!
    end

    test "Unauthenticated routes don't have a #current_user" do
      get unauthenticated_path
      assert_response :success
      assert_nil assigns(:current_user)
    end

    test "Unauthenticated routes don't trigger the unauthenticated error when calling #current_user" do
      get unauthenticated_checking_current_user_path
      assert_response :success
      assert_nil assigns(:current_user)
    end

    test 'Authenticated routes work only if HTTP_AUTHORIZATION header is set' do
      user = create(:user)
      get authenticated_path, headers: auth_token(user.token)
      assert_response :success
      refute_nil assigns(:current_user)
      assert_equal user.id, JSON.parse(response.body)['id']
    end

    test 'Authenticated routes raise Errors::Unauthorized if token is missing' do
      get authenticated_path
      assert_response :unauthorized
      assert_nil assigns(:current_user)

      error_body = JSON.parse(response.body)['errors'].first

      assert_equal 'Unauthorized', error_body['title']
      assert_equal "Authorization token is missing or it is invalid.", error_body['detail']
    end

    test "Authenticated routes raise Errors::Unauthorized if token isn't found" do
      user = build(:user)
      get authenticated_path, headers: auth_token(user.token)
      assert_response :unauthorized
      assert_nil assigns(:current_user)
    end
  end
end

class TokenAuthenticationController < ActionController::API
  include ErrorHandling
  include TokenAuthentication

  skip_before_action :authenticate, except: [:authenticated]

  def unauthenticated; end

  def unauthenticated_checking_current_user
    current_user.present?
  end

  def authenticated
    render json: { id: current_user.id }
  end
end
