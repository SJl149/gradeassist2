class DropGradeCategories < ActiveRecord::Migration
  def change
    drop_table :grade_categories
  end
end
