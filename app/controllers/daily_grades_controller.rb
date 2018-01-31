class DailyGradesController < ApplicationController
  respond_to :html, :json

  def edit
    @daily_grade = DailyGrade.find(params[:id])
  end

  def update
    @daily_grade = DailyGrade.find(params[:id])
    @course = Course.find(params[:course_id])

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

  def grades
    @course = Course.find(params[:course_id])
    @students = @course.students.order(:family_name)

    @class_date = params[:date]&.to_date
    @category = params[:category]

    @student_daily_grades = @students.map do |student|
      DailyGrade.find_or_create_by(student_id: student.id, class_date: @class_date, category: @category) 
    end
  end

  def update_grades
    @course = Course.find(params[:course_id])
    @student = Student.find(params[:student_id])
    date = params[:date].to_date
    category = params[:grade_category]

    @daily_grade = @student.daily_grades.find_by(class_date: date.beginning_of_day..date.end_of_day, category: category)
    respond_to do |format|
      if @daily_grade.update(daily_grade_params)
        format.html { render partial: "grade"}
        format.js
      else
        flash.now[:alert] = "Error updating grades. Please try again."
        format.html { render :edit }
      end
    end
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
