class AddCommentToDailyGrades < ActiveRecord::Migration
  def change
    add_column :daily_grades, :comment, :string
  end
end
