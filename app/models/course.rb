class Course < ActiveRecord::Base
  belongs_to :user

  validates :name, uniqueness: true
end
