class Column < ApplicationRecord
  # Relationships
  belongs_to :board
  has_many :tasks, dependent: :destroy

  # Validations
  validates :title, presence: true
end
