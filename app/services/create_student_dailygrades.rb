class CreateStudentDailygrades
  def initialize(student, course)
    @student = student
    @course = course
  end

  def call
    # Create grade_categories
    grade_categories = []
    @course.categories.each do |category|
      grade_categories << GradeCategory.create(
                     student: @student,
                     name: category.name,
                     weight: category.weight
      )
    end

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
      grade_categories.each do |grade_category|
        DailyGrade.create(
          class_date: classdate,
          grade_category: grade_category
        )
      end
      Attendance.create(
        class_date: classdate,
        student: @student
      )
    end
  end

end
