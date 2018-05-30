class FinalReportPdf
  include Prawn::View

  def initialize(current_user, course)
    @document = Prawn::Document.new(:page_layout => :landscape)
    @current_user = current_user
    @course = course
    @students = @course.students.order(:family_name)
    @categories = @course.categories
    grades_table
  end

  def grades_table
    title
    num_categories = @categories.size + 3
    move_down 20
    table grades_table_rows do
      row(0).font_style = :bold
      columns(1..num_categories).align = :center
      self.header = true
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.column_widths = {(num_categories - 1) => 80, num_categories => 80}
      self.cell_style = {:valign => :center}
    end
  end

  def title
    text "    #{@current_user.username}          #{@course.name}", size: 16, style: :bold
  end

  def grades_table_rows
    [table_header] +
    @students.map  do |student|
      student_line(student)
    end
  end

  def table_header
    column_names = ["Name", "Absences"]
    @categories.each { |cat| column_names << cat.name }
    column_names << "Total Avg w/o Absences"
    column_names << "Total Avg w/  Absences"
    column_names
  end

  def student_line(student)
    attendance = student_attendance(student)
    line = ["#{student.family_name}, #{student.given_name} (#{student.nickname})", "#{attendance}"]
    final_grade = 0
    @categories.each do |category|
      student_category_average = student.daily_grades.where(category: category.name).average(:grade).to_i
      final_grade += student_category_average * (category.weight / 100.0)
      line << student_category_average
    end
    line << "#{final_grade.to_i} / #{letter_grade(final_grade)}"
    line << "#{adjusted_final_grade(attendance, final_grade)}"#adjusted_final_grade(attendance, final_grade)
  end

  def student_attendance(student)
    student.attendances.where(status: 2).count + (student.attendances.where(status: 1).count / 3)
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
