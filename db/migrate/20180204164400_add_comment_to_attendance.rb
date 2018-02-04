class AddCommentToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :comment, :string
  end
end
