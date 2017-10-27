class TaskSerializer < ApplicationSerializer
  type 'tasks'

  attributes :title, :created_at, :updated_at
end
