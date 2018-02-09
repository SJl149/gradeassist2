module StudentsHelper
  def ordered_by_family_name(students)
    students.sort_by { |student| student.family_name }
  end
end
