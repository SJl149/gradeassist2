class FinalReportPdf
  include Prawn::View

  def initialize(current_user, course)
    @document = Prawn::Document.new(:page_layout => :landscape)
    @current_user = current_user
    @course = course
    @students = @course.students.order(:family_name)
    @categories = @course.categories
    title
    grades_table
  end

  def title
    text "#{@current_user.username}     #{@course.name}", size: 16, style: :bold
  end

  def grades_table
    move_down 20
    table grades_table_rows do
      row(0).font_style = :bold
      columns(1..7).align = :center
      self.header = true
    end
  end

  def grades_table_rows
    [table_header] +
    @students.map  do |student|
      [student_line]
    end
  end

  def table_header
    column_names = ["Name", "Absences"]
    @categories.each { |cat| column_names << cat.name }
    column_names << "Total Avg w/o Absences"
    column_names << "Total Avg w/ Absences"
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
    line << final_grade.to_i
    if attendance == 5
      # reduce by one letter grade
    elsif attendance >= 6
      line << "F"
    else
      line << final_grade.to_i
    end
    line
  end

  def student_attendance(student)
    student.attendances.where(status: 2).count + (student.attendances.where(status: 1).count / 3)
  end
end
