module WelcomeHelper
  def non_class_days(class_days)
    [0,1,2,3,4,5,6] - class_days.map { |cd| ClassDay.day_of_weeks[cd.day_of_week] }
  end
end
