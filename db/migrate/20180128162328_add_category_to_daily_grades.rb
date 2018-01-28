class AddCategoryToDailyGrades < ActiveRecord::Migration
  def change
    add_column :daily_grades, :category, :string
  end
end
