class DropSemesters < ActiveRecord::Migration
  def change
    drop_table :semesters do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.integer :course_id
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
