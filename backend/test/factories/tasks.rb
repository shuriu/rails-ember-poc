FactoryGirl.define do
  factory :task do
    title { Faker::Company.bs }
    association :column, strategy: :build
  end
end
