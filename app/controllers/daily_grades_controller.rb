class DailyGradesController < ApplicationController
  def submit_grades
    @course = Course.find(params[:course_id])
    @students = @course.students.order(:family_name)
    @categories = []
    @course.categories.each { |cat| @categories << cat.name }

  end

  def grades_collection
    @class_date = params[:date]
    @category = params[:category_name]
    params[:student_grades].each do |key, value|
      student_id = key.to_i
      DailyGrade.create(daily_grade_params(value), student_id: student_id, class_date: @class_date, category: @category)
    end

    redirect_to root_path
  end

  def date_selector
    class_days = []
    @course.class_days.each { |class_day| class_days << class_day[:day_of_week] }
    holidays = []
    @course.holidays.each { |holiday| holidays << holiday.class_date.to_date }
    date_selection = Date.today.to_date

    if date_selection >= @course.start_date.to_date && date_selection <= @course.end_date.to_date
      while class_days.exclude?(date_selection.wday) || holidays.include?(date_selection)
        date_selection = date_selection.next_day(1)
      end
      date_selection
    else
      @course.start_date.to_date
    end
  end

  private

  def daily_grade_params(my_params)
    my_params.permit(:class_date, :grade, :student_id, :category)
  end
end
