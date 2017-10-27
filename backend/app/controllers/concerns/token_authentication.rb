module TokenAuthentication
  extend ActiveSupport::Concern

  included do
    include ActionController::HttpAuthentication::Token::ControllerMethods
    before_action :authenticate
  end

  def current_user
    @current_user
  end

  protected

  def authenticate
    authenticate_with_token || unauthorized!
  end

  def authenticate_with_token
    authenticate_with_http_token do |token, _|
      @current_user = User.find_by(token: token)
    end
  end

  def unauthorized!
    raise Errors::Unauthorized, "Authorization token is missing or it is invalid."
  end
end
