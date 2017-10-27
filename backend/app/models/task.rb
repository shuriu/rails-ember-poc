class Task < ApplicationRecord
  # Relationships
  belongs_to :column

  # Validations
  validates :title, presence: true
end
