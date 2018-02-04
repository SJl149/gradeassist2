class Comment < ActiveRecord::Base
  belongs_to :student

  def self.for_date(date)
    date = date.to_date
    where(class_date: date.beginning_of_day..date.end_of_day).first
  end
end
