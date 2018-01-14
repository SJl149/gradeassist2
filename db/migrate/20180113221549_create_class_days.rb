class CreateClassDays < ActiveRecord::Migration
  def change
    create_table :class_days do |t|
      t.integer :day_of_week
      t.references :semester, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
