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
  end

  # Grade Breakdown table
  def grades_table
    title("Grade Breakdown")
    num_categories = @categories.size + 3
    move_down 10

    table grades_table_rows do
      row(0).align = :center
      columns(1..num_categories).align = :center
      self.header = true
      rows(1..-1).size = 10
      self.row_colors = ["F0F0F0", "FFFFFF"]
      self.column_widths = {(num_categories - 1) => 80, num_categories => 80}
      self.cell_style = {:valign => :center}
      self.width = 700
    end
  end

  def grades_table_rows
    [table_header] +
    @students.map do |student|
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
      column(9).background_color = "F0F0F0"
      columns(1..9).align = :center
      row(0).columns(2..9).size = 8
      self.header = true
      self.column_widths = { 2 => 25, 3 => 25, 4 => 25, 5 => 28, 6 => 150, 7 => 32, 8 => 32, 9 => 32}
      self.cell_style = {:valign => :top}
    end
  end

  def final_report_rows
    [["Student Name \n (official)", "Name \n (In Class)", "\# Abs", "Cert Yes", "Cert No", "Rept", "Comments, Reasons, etc. \n (if fail or repeated.)", "Final \nLetter\nGrade", "Adj.\nGrade\nfor\nAbs.", "Admin\nUse\nOnly"]] +
    @students.map do |student|
      attendance = student_attendance(student)
      ["#{student.family_name}, #{student.given_name}", "#{student.nickname}", "#{attendance}", "", "", "", "", "#{letter_grade(@final_grades_hash[student.id])}", "#{adjusted_final_grade(attendance, @final_grades_hash[student.id])}", ""]
    end
  end

  # Helper methods for both forms
  def title(form_name)
    formatted_text [ {text: "#{form_name}: ", size: 14},
                     {text: "#{@course.name}     #{@current_user.username}", size: 14, styles: [:bold]}]
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
