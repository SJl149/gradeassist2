class DailyGrade < ActiveRecord::Base
  belongs_to :student

  def self.find_or_create(class_date, category)
    self.where(class_date: class_date.beginning_of_day..class_date.end_of_day, category: category).first || self.create(class_date: class_date, category: category)
  end
end
