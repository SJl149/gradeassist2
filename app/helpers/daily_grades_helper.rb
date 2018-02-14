module DailyGradesHelper
  def current_classdate(grade)
    return "success" if grade == Date.today.to_date
  end
end
