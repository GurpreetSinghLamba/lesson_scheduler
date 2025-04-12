class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { student: 0, teacher: 1 }

  # As a teacher
  has_many :lessons, foreign_key: :teacher_id, dependent: :destroy
  
  # As a student
  has_many :enrollments, foreign_key: :student_id, dependent: :destroy
  has_many :enrolled_lessons, through: :enrollments, source: :lesson

end
