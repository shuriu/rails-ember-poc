require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test 'belongs to column' do
    task = build(:task)
    assert_respond_to task, :column, 'has a column association'
    assert_equal 'Column', task.column.class.to_s, 'has a column parent'
  end

  test 'valid with correct attributes' do
    column = create(:column)
    task   = build(:task, title: nil, column: nil)
    refute task.valid?, 'invalid without title'
    assert_match /blank/, task.errors[:title].first, 'has a presence error'

    task.title = 'Initial'
    assert_match /exist/, task.errors[:column].first, 'has a column presence error'
    refute task.valid?, 'invalid without column'

    task.column = column
    assert task.valid?, 'valid with all attributes'
  end
end
