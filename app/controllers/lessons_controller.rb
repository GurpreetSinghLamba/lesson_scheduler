class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  before_action :authorize_teacher, only: [:new, :create, :edit, :update, :destroy]

  def index
    if current_user.teacher?
      @lessons = current_user.lessons
    else
      @lessons = Lesson.all
    end
  end

  def show
    @enrollment = current_user.enrollments.find_by(lesson_id: @lesson.id)
  end

  def new
    @lesson = current_user.lessons.build
  end

  def create
    if lesson_params[:status].present? && lesson_params[:status].is_a?(String)
      status_key = Lesson.statuses.key(lesson_params[:status].to_i)
      params[:lesson][:status] = status_key if status_key
    end
    @lesson = current_user.lessons.build(lesson_params)

    if @lesson.save
      redirect_to @lesson, notice: 'Lesson was successfully created.'
    else
      render :new
    end
  end

  def update
    if lesson_params[:status].present? && lesson_params[:status].is_a?(String)
      status_key = Lesson.statuses.key(lesson_params[:status].to_i)
      params[:lesson][:status] = status_key if status_key
    end
    if @lesson.update(lesson_params)
      redirect_to @lesson, notice: 'Lesson was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @lesson.destroy
    redirect_to lessons_url, notice: 'Lesson was successfully destroyed.'
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:subject, :start_time, :end_time, :status)
  end

  def authorize_teacher
    unless current_user.teacher?
      redirect_to root_path, alert: 'Only teachers can perform this action.'
    end
  end
end