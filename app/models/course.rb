class Course < ActiveRecord::Base
  belongs_to :user
  has_many :holidays
  has_many :class_days
  has_many :categories
  has_many :students

  accepts_nested_attributes_for :holidays, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :class_days, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :categories, reject_if: :all_blank, allow_destroy: true

  validates :name, uniqueness: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
