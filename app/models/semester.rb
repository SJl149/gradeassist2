class Semester < ActiveRecord::Base
  belongs_to :course
  has_many :holidays
  has_many :class_days

  accepts_nested_attributes_for :holidays
  accepts_nested_attributes_for :class_days

  validates :start_date, presence: true
  validates :end_date, presence: true
end
