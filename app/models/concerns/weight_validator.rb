class WeightValidator < ActiveModel::Validator
  def validate(record)
    if record.weight_was
      update_weight = record.weight_was
    else
      update_weight = 0
    end
    if Category.where(course_id: record.course_id).sum(:weight) + record.weight - update_weight > 100
      record.errors.add(:weight, "Total percentage of grade categories is higher than 100!")
    end
  end
end
