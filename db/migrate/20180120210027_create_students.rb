class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :given_name
      t.string :family_name
      t.string :nickname
      t.string :email
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
