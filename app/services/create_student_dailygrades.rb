class CreateStudentDailygrades
  def initialize(student, course)
    @student = student
    @course = course
  end

  def call
    # Set schedule
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

    # Create daily_grades and attendances
    course_schedule.each do |classdate|
      Attendance.create(
        class_date: classdate,
        student: @student
      )
    end
  end

end
