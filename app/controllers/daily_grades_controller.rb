class DailyGradesController < ApplicationController
  respond_to :html, :json

  def submit_grades
    @course = Course.find(params[:course_id])
    @students = @course.students.order(:family_name)
    @categories = []
    @course.categories.each { |cat| @categories << cat.name }
    @student_daily_grades = []
    @students.each { |student| @student_daily_grades << DailyGrade.create(student: student) }
  end

  def edit
    @course = Course.find(params[:course_id])
    @students = @course.students.order(:family_name)
    @categories = []
    @course.categories.each { |cat| @categories << cat.name }
  end

  def update
    @daily_grade = DailyGrade.find(params[:id])
    @course = Course.find(params[:course_id])
    @category = params[:category_name]
    @class_date = params[:date]

    respond_to do |format|
      if @daily_grade.update(daily_grade_params)
        format.html { redirect_to(daily_grades_path(course: @course)) }
        format.json { respond_with_bip(@daily_grade) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@daily_grade) }
      end
    end
  end

  def create_grades
    @daily_grades = []
    params[:student_grades].each do |key, value|
      DailyGrade.new(daily_grade_params(value))
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

  def daily_grade_params
    params.require(:daily_grade).permit(:class_date, :grade, :student_id, :category)
  end
end
