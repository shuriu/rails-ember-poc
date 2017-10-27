require 'test_helper'

class BoardTest < ActiveSupport::TestCase
  test 'belongs to user' do
    board = build(:board)
    assert_respond_to board, :user, 'has a user association'
    assert_equal 'User', board.user.class.to_s, 'has a user parent'
  end

  test 'has many columns' do
    board = build(:board_with_columns, columns_count: 3)
    assert_respond_to board, :columns, 'has a :columns association'
    assert_equal 3, board.columns.size, 'has 3 columns'
  end

  test 'destroys dependent columns' do
    board = create(:board_with_columns, columns_count: 3)
    assert_equal 3, Column.count

    board.destroy
    assert_equal 0, Column.count
  end

  test 'valid with correct attributes' do
    board = build(:board, title: nil)
    refute board.valid?, 'invalid without title'
    assert_match /blank/, board.errors[:title].first, 'has a presence error'

    board.title = 'Initial'
    assert board.valid?, 'valid with all attributes'
  end
end
