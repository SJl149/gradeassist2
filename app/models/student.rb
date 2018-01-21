class Student < ActiveRecord::Base
  belongs_to :course

  before_save :assign_nickname

  validates :family_name, presence: true
  validates :given_name, presence: true
  validates :course_id, presence: true
  validates :email, format: { with: Devise.email_regexp,
                              message: "Invalid email.",
                              allow_blank: true
  }

  private
  def assign_nickname
    if self.nickname.empty?
      self.nickname = self.given_name
    end
  end
end
