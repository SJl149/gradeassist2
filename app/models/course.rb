class Course < ActiveRecord::Base
  belongs_to :user
  has_many :semesters

  accepts_nested_attributes_for :semesters

  validates :name, uniqueness: true
end
