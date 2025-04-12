class EnrollmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: [:create]
  before_action :authorize_student, only: [:create, :destroy]

  def create
    @enrollment = current_user.enrollments.build(lesson: @lesson)
    
    if @enrollment.save
      redirect_to @lesson, notice: 'Successfully enrolled in lesson.'
    else
      debugger
      redirect_to @lesson, alert: @enrollment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @enrollment = current_user.enrollments.find(params[:id])
    lesson = @enrollment.lesson

    if lesson.scheduled? && @enrollment.destroy
      redirect_to lesson, notice: 'Successfully unenrolled from lesson.'
    else
      redirect_to lesson, alert: 'Could not unenroll from lesson.'
    end
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end

  def authorize_student
    unless current_user.student?
      redirect_to root_path, alert: 'Only students can perform this action.'
    end
  end
end