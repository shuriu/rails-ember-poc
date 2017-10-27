class SessionsController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  def create
    user = User.find_by(email: auth_params[:email])
    raise Errors::Unauthorized, 'Missing or incorrect credentials.' if user.blank?

    if user.valid_password?(auth_params[:password])
      render json: { token: user.token }
    else
      raise Errors::Unauthorized, 'Missing or incorrect credentials.'
    end
  end

  def destroy
    @current_user.token = User.generate_unique_secure_token
    @current_user.save(validate: false)
    head :no_content
  end

  private

  def auth_params
    params.require(:session).permit(:email, :password)
  end
end
