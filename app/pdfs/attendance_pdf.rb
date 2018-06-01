class AttendancePdf
  include Prawn::View

  def initialize(current_user, course)
    @current_user = current_user
    @course = course
    @students = @course.students
    attendance_record
  end

  def attendance_record
    formatted_text [ {text: "Attendance: ", size: 14},
                     {text: "#{@course.name}     #{@current_user.username}", size: 14, styles: [:bold]}]
    move_down 10
    table attendance_rows do

    end
  end

  def set_schedule
    start_date = @course.start_date.to_date
    end_date = @course.end_date.to_date
    class_days = []
    @course.class_days.each do |class_day|
      class_days << class_day[:day_of_week]
    end
    holidays = []
    @course.holidays.each do |holiday|
      holidays << holiday.class_date.to_date
    end

    course_schedule = []
    (start_date..end_date).each do |cal_date|
      if class_days.include?(cal_date.wday) && holidays.exclude?(cal_date)
        course_schedule << cal_date
      end
    end
    course_schedule
  end

  def attendance_rows
    schedule = set_schedule
    
  end
end
