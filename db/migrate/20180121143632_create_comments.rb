class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content
      t.datetime :class_date
      t.references :student, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
