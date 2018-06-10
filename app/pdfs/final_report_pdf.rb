class FinalReportPdf
  include Prawn::View

  def initialize(current_user, course)
    @document = Prawn::Document.new(:page_layout => :landscape)
    @current_user = current_user
    @course = course
    @students = @course.students.order(:family_name)
    @categories = @course.categories
    @final_grades_hash = {}
    grades_table
    final_report
    attendance_record
  end

  # Grade Breakdown table
  def grades_table
    title("Grade Breakdown")
    num_categories = @categories.size + 3
    move_down 10

    table grades_table_rows do
      row(0).align = :center
      row(0).border_bottom_width = 2
      columns(1..num_categories).align = :center
      self.header = true
      rows(1..-1).size = 10
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.column_widths = {(num_categories - 1) => 80, num_categories => 80}
      self.cell_style = {:valign => :center}
      self.width = 700
    end
  end

  def grades_table_rows
    [grades_table_header] +
    @students.map do |student|
      student_line(student)
    end
  end

  def grades_table_header
    column_names = ["Name", "Absences"]
    @categories.each { |cat| column_names << cat.name }
    column_names << "Total Avg w/o Absences"
    column_names << "Total Avg w/  Absences"
    column_names
  end

  def student_line(student)
    attendance = student_total_absences(student)
    line = ["#{student.family_name}, #{student.given_name} (#{student.nickname})", "#{attendance}"]
    final_grade = 0
    @categories.each do |category|
      student_category_average = student.daily_grades.where(category: category.name).average(:grade).to_i
      final_grade += student_category_average * (category.weight / 100.0)
      line << student_category_average
    end
    @final_grades_hash[student.id] = final_grade.to_i
    line << "#{final_grade.to_i} / #{letter_grade(final_grade)}"
    line << "#{adjusted_final_grade(attendance, final_grade)}"
    line
  end

  # Final Grade Report
  def final_report
    self.start_new_page(:layout => :portrait)
    title("Final Report")
    move_down 20

    table final_report_rows do
      row(0).align = :center
      row(0).border_bottom_width = 2
      column(9).background_color = "DDDDDD"
      columns(1..9).align = :center
      row(0).columns(2..9).size = 8
      self.header = true
      self.column_widths = { 2 => 25, 3 => 25, 4 => 25, 5 => 28, 6 => 150, 7 => 32, 8 => 32, 9 => 32}
      self.cell_style = {:valign => :top}
    end
  end

  def final_report_rows
    report_rows = [["Student Name \n (official)", "Name \n (In Class)", "\# Abs", "Cert Yes", "Cert No", "Rept", "Comments, Reasons, etc. \n (if fail or repeated.)", "Final \nLetter\nGrade", "Adj.\nGrade\nfor\nAbs.", "Admin\nUse\nOnly"]]
    @students.each do |student|
      attendance = student_total_absences(student)
      report_rows << ["#{student.family_name}, #{student.given_name}", "#{student.nickname}", "#{attendance}", "", "", "", "", "#{letter_grade(@final_grades_hash[student.id])}", "#{adjusted_final_grade(attendance, @final_grades_hash[student.id])}", ""]
    end
    while report_rows.size < 25
      report_rows << [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
    end
    report_rows
  end

  # Attendance record for class
  def attendance_record
    schedule = course_schedule
    schedule.each_slice(20) do |schedule_slice|
      self.start_new_page

      title("Attendance")
      move_down(10)

      table attendance_record_rows(schedule_slice) do
        self.column_widths = { 0 => 150 }
        row(0).columns(1..-1).size = 8
        row(0).border_bottom_width = 2
        columns(1..-1).align = :center
        self.row_colors = ["FFFFFF", "DDDDDD"]
      end
    end
  end

  def attendance_record_rows(schedule_slice)
    [attendance_record_table_header(schedule_slice)] +
    @students.map do |student|
      student_attendance_line(student, schedule_slice)
    end
  end

  def student_attendance_line(student, schedule_slice)
    line = ["#{student.family_name}, #{student.given_name}"]
    schedule_slice.each do |date_of_class|
      attendance_status = student.attendances.find_by(class_date: date_of_class.beginning_of_day..date_of_class.end_of_day)
      case attendance_status.status
      when "present"
        line << "P"
      when "late"
        line << "L"
      when "absent"
        line << "A"
      else
        line << " "
      end
    end
    line
  end

  def attendance_record_table_header(schedule)
    column_names = ["Name"]
    schedule.each { |day_of_class| column_names << day_of_class.strftime("%-m / %d") }
    column_names
  end

  # Helper methods
  def title(form_name)
    formatted_text [ {text: "#{form_name}: ", size: 14},
                     {text: "#{@course.name}     #{@current_user.username}", size: 14, styles: [:bold]}]
  end

  def student_total_absences(student)
    student.attendances.where(status: 2).count + (student.attendances.where(status: 1).count / 3)
  end

  def course_schedule
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

    schedule = []
    (start_date..end_date).each do |cal_date|
      if class_days.include?(cal_date.wday) && holidays.exclude?(cal_date)
        schedule << cal_date
      end
    end
    schedule
  end

  def adjusted_final_grade(attendance, final_grade)
    if attendance == 5
      letter_grade(final_grade).tr('ABCD', 'BCDF')
    elsif attendance >= 6
      "F"
    else
      letter_grade(final_grade)
    end
  end

  def letter_grade(grade)
    case grade.to_i
    when 96..100
      "A"
    when 90..95
      "A-"
    when 87..89
      "B+"
    when 84..86
      "B"
    when 80..83
      "B-"
    when 77..79
      "C+"
    when 74..76
      "C"
    when 70..73
      "C-"
    when 67..69
      "D+"
    when 64..66
      "D"
    else
      "F"
    end
  end
end
