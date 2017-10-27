class UserSerializer < ApplicationSerializer
  type 'users'

  attributes :email

  has_many :boards
end
