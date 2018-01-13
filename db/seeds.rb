User.destroy_all
Course.destroy_all

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
  user: user1
)

course2 = Course.create(
  name: 'Intro Fall 2017',
  user: user1
)

puts "Seeds finshed"
puts "#{User.count} users created"
puts "#{Course.count} courses created"
