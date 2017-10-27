class BoardsController < ApplicationController
  deserializable_resource :board, only: [:create, :update]

  def index
    boards = @current_user.boards.order(created_at: :asc)
    render jsonapi: boards, include: params[:include]
  end

  def show
    board = @current_user.boards.includes(columns: :tasks).find(params[:id])
    render jsonapi: board, include: params[:include]
  end

  def create
    board = @current_user.boards.build(board_params)

    if board.save
      render jsonapi: board
    else
      render jsonapi_errors: board.errors, status: :unprocessable_entity
    end
  end

  def update
    board = @current_user.boards.find(params[:id])

    if board.update(board_params)
      render jsonapi: board
    else
      render jsonapi_errors: board.errors, status: :unprocessable_entity
    end
  end

  def destroy
    board = @current_user.boards.find(params[:id])

    if board.destroy
      head :no_content
    else
      render jsonapi_errors: board.errors, status: :unprocessable_entity
    end
  end

  private

  def board_params
    params.require(:board).permit(:title)
  end
end
