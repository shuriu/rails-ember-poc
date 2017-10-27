class ColumnSerializer < ApplicationSerializer
  type 'columns'

  attributes :title, :created_at, :updated_at

  belongs_to :board
  has_many :tasks
end
