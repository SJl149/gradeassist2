class CreateDailyGrades < ActiveRecord::Migration
  def change
    create_table :daily_grades do |t|
      t.integer :grade
      t.datetime :class_date
      t.references :grade_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
