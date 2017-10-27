FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'

    factory :user_with_boards do
      transient do
        boards_count 0
        columns_count 0
        tasks_count 0
      end

      after(:build) do |user, evaluator|
        user.boards = build_list(:board_with_columns, evaluator.boards_count,
          user: user,
          columns_count: evaluator.columns_count,
          tasks_count: evaluator.tasks_count
        )
      end
    end
  end
end
