class ClassDay < ActiveRecord::Base
  belongs_to :course

  enum day_of_week: {sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6}

  validates :day_of_week, uniqueness: { scope: :course_id }
end
