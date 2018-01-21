class CreateGradeCategories < ActiveRecord::Migration
  def change
    create_table :grade_categories do |t|
      t.string :name
      t.integer :weight
      t.references :student, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
