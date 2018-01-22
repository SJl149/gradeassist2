class Attendance < ActiveRecord::Base
  belongs_to :student

  enum status: { present: 0, late: 1, absent: 2 }
end
