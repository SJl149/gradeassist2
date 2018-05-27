class FinalReportPdf
  include Prawn::View

  def initialize(current_user, course)
    @current_user = current_user
    @course = course
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
    [["Name", "Absences", "Class Participation", "Homework", "Quiz/Test", "Final Test/ Project", "Total Avg w/o Absences", "Total Avg w/ Absences"]] +
    @course.students.map  do |student|
      ["#{student.family_name}, #{student.given_name} (#{student.nickname})", "", "", "", "", "", "", ""]
    end
  end
end
