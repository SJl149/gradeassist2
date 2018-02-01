class DailyGradesController < ApplicationController
  respond_to :html, :json

  def edit
    @daily_grade = DailyGrade.find(params[:id])
  end

  def update
    @daily_grade = DailyGrade.find(params[:id])

    respond_to do |format|
      if @daily_grade.update(daily_grade_params)
        format.html { redirect_to(daily_grades_path) }
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
    @category = params[:category_name]

    @student_daily_grades = []
    @students.each do |student|
      @student_daily_grades << student.daily_grades.find_or_create_by(class_date: @class_date.beginning_of_day..@class_date.end_of_day, category: @category)
    end
  end

  private

  def daily_grade_params
    params.require(:daily_grade).permit(:class_date, :grade, :student_id, :category)
  end
end
