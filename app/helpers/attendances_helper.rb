module AttendancesHelper
  def attendance_label(status)
    case status
    when 'present' then "success"
    when 'late' then "warning"
    else "danger"
    end
  end
end
