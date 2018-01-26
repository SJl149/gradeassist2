class AttendancesController < ApplicationController
  respond_to :html, :json

  def show
    @course = Course.find(params[:course_id])
    @students = @course.students.order(:family_name)
    @attendance_date = params[:date]&.to_date || date_selector
  end

  def update
    @student = Student.find(params[:student_id])
    date = params[:date].to_date
    @attendance = @student.attendances.find_by(class_date: date.beginning_of_day..date.end_of_day)

    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { render partial: "attendance" }
        format.js
      else
        flash.now[:alert] = "Error updating attendance. Please try again."
        format.html { render :edit}
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

  def attendance_params
    params.require(:attendance).permit(:class_date, :status, :date)
  end
end
