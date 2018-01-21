class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.datetime :class_date
      t.integer :status
      t.references :student, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
