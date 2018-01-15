class Category < ActiveRecord::Base
  belongs_to :course

  validate :less_than_hundred

  private

  def less_than_hundred
    if self.weight_was
      update_weight = self.weight_was
    else
      update_weight = 0
    end
    if Category.where(course_id: self.course_id).sum(:weight) + self.weight - update_weight > 100
      errors.add(:weight, "Total percentage of grade categories is higher than 100!")
    end
  end
end
