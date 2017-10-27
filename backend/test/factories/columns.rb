FactoryGirl.define do
  factory :column do
    title { Faker::Company.buzzword }
    association :board, strategy: :build

    factory :column_with_tasks do
      transient do
        tasks_count 3
      end

      after(:build) do |column, evaluator|
        column.tasks = build_list(:task, evaluator.tasks_count, column: column)
      end
    end
  end
end
