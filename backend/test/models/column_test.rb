require 'test_helper'

class ColumnTest < ActiveSupport::TestCase
  test 'belongs to board' do
    column = build(:column)
    assert_respond_to column, :board, 'has a board association'
    assert_equal 'Board', column.board.class.to_s, 'has a board parent'
  end

  test 'has many tasks' do
    column = build(:column_with_tasks)
    assert_respond_to column, :tasks, 'has a :tasks association'
    assert_equal 3, column.tasks.size, 'has 3 tasks'
  end

  test 'destroys dependent tasks' do
    column = create(:column_with_tasks)
    assert_equal 3, Task.count

    column.destroy
    assert_equal 0, Task.count
  end

  test 'valid with correct attributes' do
    board   = create(:board)
    column  = build(:column, title: nil, board: nil)
    refute column.valid?, 'invalid without title'
    assert_match /blank/, column.errors[:title].first, 'has a presence error'

    column.title = 'Initial'
    assert_match /exist/, column.errors[:board].first, 'has a board presence error'
    refute column.valid?, 'invalid without board'

    column.board = board
    assert column.valid?, 'valid with all attributes'
  end
end
