class AddCourseToHolidays < ActiveRecord::Migration
  def change
    add_reference :holidays, :course, index: true, foreign_key: true
  end
end
