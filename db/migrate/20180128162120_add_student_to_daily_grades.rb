class AddStudentToDailyGrades < ActiveRecord::Migration
  def change
    add_reference :daily_grades, :student, index: true, foreign_key: true
  end
end
