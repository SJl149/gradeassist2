class ClassDay < ActiveRecord::Base
  belongs_to :course

  validates :day_of_week, presence: true
end
