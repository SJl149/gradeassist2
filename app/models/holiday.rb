class Holiday < ActiveRecord::Base
  belongs_to :course

  validates :class_date, presence: true
end
