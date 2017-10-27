FactoryGirl.define do
  factory :board do
    title { Faker::Company.name }
    association :user, strategy: :build

    factory :board_with_columns do
      transient do
        columns_count 0
        tasks_count 0
      end

      after(:build) do |board, evaluator|
        board.columns = build_list(:column_with_tasks, evaluator.columns_count,
          board: board,
          tasks_count: evaluator.tasks_count
        )
      end
    end
  end
end

