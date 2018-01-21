class GradeCategory < ActiveRecord::Base
  belongs_to :student
  has_many :daily_grades
end
