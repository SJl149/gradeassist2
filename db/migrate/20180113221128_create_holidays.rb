class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.string :name
      t.datetime :class_date
      t.references :semester, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
