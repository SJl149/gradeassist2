class RemoveSemesterFromClassDays < ActiveRecord::Migration
  def change
    remove_reference :class_days, :semester, index: true, foreign_key: true
  end
end
