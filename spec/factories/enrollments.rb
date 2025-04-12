FactoryBot.define do
    factory :enrollment do
      association :student, factory: [:user, :student]
      association :lesson
    end
  end