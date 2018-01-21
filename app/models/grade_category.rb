class GradeCategory < ActiveRecord::Base
  belongs_to :student
  has_many :daily_grades

  accepts_nested_attributes_for :daily_grades, allow_destroy: true
end
