class Attendance < ActiveRecord::Base
  belongs_to :student

  enum status: { present: 0, late: 1, absent: 2 }

  def self.for_date(date)
    date = date.to_date
    where(class_date: date.beginning_of_day..date.end_of_day).first
  end
end
