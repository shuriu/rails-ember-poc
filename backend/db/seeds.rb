FactoryGirl.create(:user_with_boards,
  email: 'admin@example.com',
  password: 'password',
  boards_count: 3,
  columns_count: 3,
  tasks_count: 7
)
