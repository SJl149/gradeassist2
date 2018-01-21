User.destroy_all
Course.destroy_all
Holiday.destroy_all
ClassDay.destroy_all
Category.destroy_all
Student.destroy_all

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
  start_date: 10.days.ago.to_date,
  end_date: 3.months.from_now.to_date,
  user: user1
)

course2 = Course.create(
  name: 'Intro Fall 2017',
  start_date: 10.days.ago.to_date,
  end_date: 3.months.from_now.to_date,
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

puts "Seeds finshed"
puts "#{User.count} users created"
puts "#{Course.count} courses created"
puts "#{Holiday.count} holidays created"
puts "#{ClassDay.count} class_days created"
puts "#{Category.count} categories created"
puts "#{Student.count} students created"
