class RemoveStudentFromGradeCategories < ActiveRecord::Migration
  def change
    remove_reference :grade_categories, :student, index: true, foreign_key: true
  end
end
