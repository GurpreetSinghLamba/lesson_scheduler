class Lesson < ApplicationRecord
  belongs_to :teacher, class_name: 'User'
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments, source: :student

  enum status: { scheduled: 0, completed: 1, canceled: 2 }

  validates :subject, :start_time, :end_time, presence: true
  validates :end_time, comparison: { greater_than: :start_time }
  validate :start_time_in_future, :minimum_duration, :no_teacher_overlap

  private

  def start_time_in_future
    errors.add(:start_time, "must be in the future") if start_time.present? && start_time < Time.current
  end

  def minimum_duration
    return unless start_time.present? && end_time.present?
    
    if (end_time - start_time) < 30.minutes
      errors.add(:end_time, "must be at least 30 minutes after start time")
    end
  end

  def no_teacher_overlap
    return unless start_time.present? && end_time.present? && teacher_id.present?

    overlapping_lessons = Lesson.where(teacher_id: teacher_id)
                              .where.not(id: id)
                              .where.not(status: :canceled)
                              .where("(start_time < ? AND end_time > ?) OR (start_time < ? AND end_time > ?) OR (start_time >= ? AND end_time <= ?)", 
                                     end_time, start_time, end_time, start_time, start_time, end_time)

    if overlapping_lessons.exists?
      errors.add(:base, "Teacher has another lesson scheduled during this time")
    end
  end
end