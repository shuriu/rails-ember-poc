class BoardSerializer < ApplicationSerializer
  type 'boards'

  attributes :title, :created_at, :updated_at

  has_many :columns
  belongs_to :user
end
