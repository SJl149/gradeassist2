class AddArchiveToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :archive, :boolean
  end
end
