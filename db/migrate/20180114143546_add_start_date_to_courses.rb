class AddStartDateToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :start_date, :datetime
  end
end
