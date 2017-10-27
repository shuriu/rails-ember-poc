class Board < ApplicationRecord
  # Relationships
  has_many :columns, dependent: :destroy
  belongs_to :user

  # Validations
  validates :title, presence: true
end
