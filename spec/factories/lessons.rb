FactoryBot.define do
    factory :lesson do
      association :teacher, factory: [:user, :teacher]
      subject { Faker::Educator.course_name }
      start_time { 1.day.from_now }
      end_time { 1.day.from_now + 1.hour }
      status { :scheduled }
    end
  end