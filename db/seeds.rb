User.destroy_all
Course.destroy_all
Holiday.destroy_all
ClassDay.destroy_all
Category.destroy_all
Student.destroy_all
Attendance.destroy_all
DailyGrade.destroy_all
Comment.destroy_all

# Create Users
user1 = User.new(
  username: 'User1',
  email: 'username@gmail.com',
  password: 'password',
  password_confirmation: 'password'
)
user1.skip_confirmation!
user1.save!

user2 = User.new(
  username: 'User2',
  email: 'second@gmail.com',
  password: 'password',
  password_confirmation: 'password'
)
user2.skip_confirmation!
user2.save!

# Create Courses
course1 = Course.create(
  name: 'Toefl Fall 2017',
  start_date: DateTime.new(2018,1,15),
  end_date: DateTime.new(2018,3,15),
  user: user1
)

course2 = Course.create(
  name: 'Intro Fall 2017',
  start_date: DateTime.new(2018,1,15),
  end_date: DateTime.new(2018,3,15),
  user: user1
)

# Create Holidays
holiday1 = Holiday.create(
  name: 'Valentine\'s Day',
  class_date: DateTime.new(2018,2,14),
  course: course1
)
holiday2 = Holiday.create(
  name: 'Groundhog\'s Day',
  class_date: DateTime.new(2018,2,2),
  course: course2
)

# Create ClassDays
[1,2,3,4].each do |day|
  ClassDay.create(
    day_of_week: day,
    course: course1
  )
  ClassDay.create(
    day_of_week: day,
    course: course2
  )
end

# Create Categories
['HW', 'Participation', 'Quizzes', 'Exam'].each do |cat_name|
  course1_categories = Category.create(
                         name: cat_name,
                         weight: 25,
                         course: course1
                       )
  course2_categories = Category.create(
                        name: cat_name,
                        weight: 25,
                        course: course2
                      )
end

# Create Students
for i in 1..30 do
  i.odd? ? course = course1 : course = course2
  given_name = Faker::Name.unique.first_name
  student = Student.new(
    given_name: given_name,
    family_name: Faker::Name.unique.last_name,
    nickname: Faker::Ancient.hero + Faker::Number.digit,
    email: Faker::Internet.free_email(given_name),
    course: course
  )
  student.save!
end
students_group1 = Student.first(15)
students_group2 = Student.all - students_group1

# Create course schedule
start_date = course1.start_date.to_date
end_date = course1.end_date.to_date
class_days = [1,2,3,4]
course_schedule = []
(start_date..end_date).each do |cal_date|
  if class_days.include?(cal_date.wday)
    course_schedule << cal_date
  end
end

# Create Attendances and DailyGrades and Comments
students = students_group1 + students_group2
categories = ["HW", "Participation", "Quizzes", "Exams"]
grades = [100, 90, 80, 70, 60, 50]
comment_content = ["Great work today!", "Fell asleep in class", "Had subway trouble", "Worked hard on the assignment"]

course_schedule.each do |class_date|
  students.each do |student|
    Attendance.create(
      class_date: class_date,
      student: student
    )
    categories.each do |category|
      DailyGrade.create(
        class_date: class_date,
        category: category,
        grade: grades.sample,
        student: student
      )
    end
    if class_date.wday == 4
      Comment.create(
        class_date: class_date,
        content: comment_content.sample,
        student: student
      )
    end
  end
end

puts "Seeds finshed"
puts "#{User.count} users created"
puts "#{Course.count} courses created"
puts "#{Holiday.count} holidays created"
puts "#{ClassDay.count} class_days created"
puts "#{Category.count} categories created"
puts "#{Student.count} students created"
puts "#{Attendance.count} attendance records created"
puts "#{DailyGrade.count} daily_grades created"
puts "#{Comment.count} comments created"
