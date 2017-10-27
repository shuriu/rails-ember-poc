class TasksController < ApplicationController
  deserializable_resource :task, only: [:create, :update]
  before_action :authorize_column, only: [:create]

  def index
    tasks = @current_user.tasks.order(created_at: :asc)
    render jsonapi: tasks, include: params[:include]
  end

  def show
    task = @current_user.tasks.find(params[:id])
    render jsonapi: task, include: params[:include]
  end

  def create
    task = Task.new(task_params)

    if task.save
      render jsonapi: task
    else
      render jsonapi_errors: task.errors, status: :unprocessable_entity
    end
  end

  def update
    task = @current_user.tasks.find(params[:id])

    if task.update(task_params)
      render jsonapi: task
    else
      render jsonapi_errors: task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    task = @current_user.tasks.find(params[:id])

    if task.destroy
      head :no_content
    else
      render jsonapi_errors: task.errors, status: :unprocessable_entity
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :column_id)
  end

  def authorize_column
    unless @current_user.columns.where(id: task_params[:column_id]).exists?
      raise Errors::Forbidden, "You don't have permission for this resource."
    end
  end
end
