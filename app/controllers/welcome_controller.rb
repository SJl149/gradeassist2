class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:about, :index]

  def dashboard
    @courses = current_user.courses
    @students = Student.where(course: @courses)
    @daily_grades_date = params[:date]&.to_date || Date.today
  end

  def index
  end

  def about
  end

end
