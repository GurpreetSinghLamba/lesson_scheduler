class Enrollment < ApplicationRecord
  belongs_to :student, class_name: 'User'
  belongs_to :lesson

  validate :student_not_teacher, :no_student_overlap

  private

  def student_not_teacher
    if lesson.teacher == student
      errors.add(:student, "cannot be the teacher of the lesson")
    end
  end

  def no_student_overlap
    
    return unless student.present? && lesson.present?
    
    overlapping_lessons = student.enrolled_lessons
                               .where.not(id: lesson.id)
                               .where.not(status: :canceled)
                               .where("(start_time < ? AND end_time > ?) OR (start_time < ? AND end_time > ?) OR (start_time >= ? AND end_time <= ?)", 
                                      lesson.end_time, lesson.start_time, lesson.end_time, lesson.start_time, lesson.start_time, lesson.end_time)
    
    if overlapping_lessons.exists?
      errors.add(:base, "Student is already enrolled in another lesson during this time")
    end
  end
end