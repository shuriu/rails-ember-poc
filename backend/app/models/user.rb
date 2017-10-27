class User < ApplicationRecord
  # Relationships
  has_many :boards, dependent: :destroy
  has_many :columns, through: :boards
  has_many :tasks, through: :columns

  # Extensions
  has_secure_password
  has_secure_token

  # Validations
  validates :email, presence: true
  validates :email, uniqueness: true, if: -> { email? }
  validates :email, format: { with: /\A.+@.+\z/ }

  # Instance methods
  def valid_password?(unencrypted_password)
    BCrypt::Password.new(password_digest)
      .is_password?(unencrypted_password)
  rescue BCrypt::Errors::InvalidHash
    false
  end
end
