class Holiday < ActiveRecord::Base
  belongs_to :semester

  validates :class_date, presence: true
end
