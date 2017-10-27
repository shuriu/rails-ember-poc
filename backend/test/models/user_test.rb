require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'has many boards' do
    user = build(:user_with_boards, boards_count: 2, columns_count: 0)
    assert_respond_to user, :boards, 'has a :boards association'
    assert_equal 2, user.boards.size, 'has 2 boards'
  end

  test 'has many columns through boards' do
    user = create(:user_with_boards, boards_count: 1, columns_count: 3)
    assert_respond_to user, :columns, 'has a :columns association'
    assert_equal 3, user.columns.size, 'has 3 columns'
  end

  test 'has many tasks through columns' do
    user = create(:user_with_boards, boards_count: 1, columns_count: 1, tasks_count: 3)
    assert_respond_to user, :tasks, 'has a :tasks association'
    assert_equal 3, user.tasks.size, 'has 3 tasks'
  end

  test 'destroys dependent boards' do
    user = create(:user_with_boards, boards_count: 3, columns_count: 0)
    assert_equal 3, Board.count

    user.destroy
    assert_equal 0, Board.count
  end

  test 'valid with correct attributes' do
    user = build(:user, email: nil)
    refute user.valid?, 'invalid without email'
    assert_match /blank/, user.errors[:email].first, 'email has a presence error'

    user = build(:user, password: nil)
    refute user.valid?, 'invalid without password'
    assert_match /blank/, user.errors[:password].first, 'password has a presence error'

    user = build(:user, email: 'something')
    refute user.valid?, 'invalid wrong email format'
    assert_match /invalid/, user.errors[:email].first, 'email has a format error'

    user = build(:user, email: 'something@')
    refute user.valid?, 'invalid wrong email format'
    assert_match /invalid/, user.errors[:email].first, 'email has a format error'

    user = build(:user, email: '@something')
    refute user.valid?, 'invalid wrong email format'
    assert_match /invalid/, user.errors[:email].first, 'email has a format error'

    user.email = 'test@example.com'
    assert user.valid?, 'valid with all attributes'
    user.save

    user = build(:user, email: 'test@example.com')
    refute user.valid?, 'invalid with non-unique email'
    assert_match /taken/, user.errors[:email].first, 'has a uniqueness error'
  end

  test '#token' do
    refute build(:user).token?, 'no token initially'

    user = create(:user)
    assert user.token?, 'has token after creation'
  end

  test '#valid_password?' do
    user = build(:user, password: nil)

    refute user.valid_password?(nil)
    refute user.valid_password?('')

    user.password = 'secret'
    refute user.valid_password?('something else')
    assert user.valid_password?('secret')
  end
end
