class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
