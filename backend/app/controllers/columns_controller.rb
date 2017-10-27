class ColumnsController < ApplicationController
  deserializable_resource :column, only: [:create, :update]
  before_action :authorize_board, only: [:create]

  def index
    columns = @current_user.columns.order(created_at: :asc)
    render jsonapi: columns, include: params[:include]
  end

  def show
    column = @current_user.columns.find(params[:id])
    render jsonapi: column, include: params[:include]
  end

  def create
    column = Column.new(column_params)

    if column.save
      render jsonapi: column
    else
      render jsonapi_errors: column.errors, status: :unprocessable_entity
    end
  end

  def update
    column = @current_user.columns.find(params[:id])

    if column.update(column_params)
      render jsonapi: column
    else
      render jsonapi_errors: column.errors, status: :unprocessable_entity
    end
  end

  def destroy
    column = @current_user.columns.find(params[:id])

    if column.destroy
      head :no_content
    else
      render jsonapi_errors: column.errors, status: :unprocessable_entity
    end
  end

  private

  def column_params
    params.require(:column).permit(:title, :board_id)
  end

  def authorize_board
    unless @current_user.boards.where(id: column_params[:board_id]).exists?
      raise Errors::Forbidden, "You don't have permission for this resource."
    end
  end
end
