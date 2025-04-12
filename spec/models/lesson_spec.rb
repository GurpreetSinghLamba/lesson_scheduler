require 'rails_helper'

RSpec.describe Lesson, type: :model do
  let(:teacher) { create(:user, role: :teacher) }

  describe 'validations' do
    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should validate_comparison_of(:end_time).is_greater_than(:start_time) }

    context 'with start time in the past' do
      let(:lesson) { build(:lesson, teacher: teacher, start_time: 1.day.ago, end_time: 1.day.ago + 1.hour) }

      it 'is invalid' do
        expect(lesson).not_to be_valid
        expect(lesson.errors[:start_time]).to include("must be in the future")
      end
    end

    context 'with duration less than 30 minutes' do
      let(:lesson) { build(:lesson, teacher: teacher, start_time: 1.day.from_now, end_time: 1.day.from_now + 29.minutes) }

      it 'is invalid' do
        expect(lesson).not_to be_valid
        expect(lesson.errors[:end_time]).to include("must be at least 30 minutes after start time")
      end
    end

    context 'with overlapping lessons for same teacher' do
      let!(:existing_lesson) { create(:lesson, teacher: teacher, start_time: 1.day.from_now, end_time: 1.day.from_now + 1.hour) }
      let(:overlapping_lesson) { build(:lesson, teacher: teacher, start_time: 1.day.from_now + 30.minutes, end_time: 1.day.from_now + 1.hour + 30.minutes) }

      it 'is invalid' do
        expect(overlapping_lesson).not_to be_valid
        expect(overlapping_lesson.errors[:base]).to include("Teacher has another lesson scheduled during this time")
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:teacher).class_name('User') }
    it { should have_many(:enrollments).dependent(:destroy) }
    it { should have_many(:students).through(:enrollments).source(:student) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(scheduled: 0, completed: 1, canceled: 2) }
  end
end