require 'rails_helper'

RSpec.describe Enrollment, type: :model do
  let(:teacher) { create(:user, role: :teacher) }
  let(:student) { create(:user, role: :student) }
  let(:lesson) { create(:lesson, teacher: teacher) }

  describe 'validations' do
    context 'when student is also the teacher' do
      let(:enrollment) { build(:enrollment, student: teacher, lesson: lesson) }

      it 'is invalid' do
        expect(enrollment).not_to be_valid
        expect(enrollment.errors[:student]).to include("cannot be the teacher of the lesson")
      end
    end

    context 'with overlapping lessons for student' do
      let!(:existing_enrollment) { create(:enrollment, student: student, lesson: lesson) }
      let(:overlapping_lesson) { create(:lesson, teacher: teacher, start_time: lesson.start_time + 15.minutes, end_time: lesson.end_time + 15.minutes) }
      let(:overlapping_enrollment) { build(:enrollment, student: student, lesson: overlapping_lesson) }

      it 'is invalid' do
        expect(overlapping_enrollment).not_to be_valid
        expect(overlapping_enrollment.errors[:base]).to include("Student is already enrolled in another lesson during this time")
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:student).class_name('User') }
    it { should belong_to(:lesson) }
  end
end