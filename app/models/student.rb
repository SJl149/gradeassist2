class Student < ActiveRecord::Base
  belongs_to :course

  validates :family_name, presence: true
  validates :given_name, presence: true
  validates :course_id, presence: true
end
