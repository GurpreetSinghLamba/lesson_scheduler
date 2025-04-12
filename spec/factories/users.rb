FactoryBot.define do
    factory :user do
      email { Faker::Internet.unique.email }
      password { 'password123' }
      role { :student }
  
      trait :teacher do
        role { :teacher }
      end
  
      trait :student do
        role { :student }
      end
    end
  end