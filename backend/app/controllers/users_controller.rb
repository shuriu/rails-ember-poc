class UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    render jsonapi: user
  end

  def current
    render jsonapi: current_user
  end
end
