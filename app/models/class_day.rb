class ClassDay < ActiveRecord::Base
  belongs_to :semester

  validates :day_of_week, presence: true
end
