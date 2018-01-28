class RemoveGradeCategoryFromDailyGrades < ActiveRecord::Migration
  def change
    remove_reference :daily_grades, :grade_category, index: true, foreign_key: true
  end
end
