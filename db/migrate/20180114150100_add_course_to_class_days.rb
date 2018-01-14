class AddCourseToClassDays < ActiveRecord::Migration
  def change
    add_reference :class_days, :course, index: true, foreign_key: true
  end
end
