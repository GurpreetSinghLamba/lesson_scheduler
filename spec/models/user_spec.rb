require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'associations' do
    it { should have_many(:lessons).with_foreign_key(:teacher_id).dependent(:destroy) }
    it { should have_many(:enrollments).with_foreign_key(:student_id).dependent(:destroy) }
    it { should have_many(:enrolled_lessons).through(:enrollments).source(:lesson) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(student: 0, teacher: 1) }
  end
end

