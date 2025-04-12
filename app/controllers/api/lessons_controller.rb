class Api::LessonsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @lessons = Lesson.where('start_time > ?', Time.current).order(:start_time)
      render json: @lessons, include: :teacher
    end
  end