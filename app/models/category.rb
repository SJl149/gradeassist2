class Category < ActiveRecord::Base
  belongs_to :course

  validates_with WeightValidator
end
