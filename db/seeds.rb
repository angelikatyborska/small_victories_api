puts 'Seeds: start'

puts 'Cleaning the database...'

Victory.destroy_all
User.destroy_all

puts 'Creating users...'

users_data = 5.times.with_object([]) do |n, users_data|
  users_data << {
    email: Faker::Internet.safe_email,
    nickname: Faker::Internet.user_name
  }
end

users = User.create!(users_data)

puts 'Creating victories...'

victories_data = users.each.with_object([]) do |user, victories_data|
  5.times do
    victories_data << {
      user_id: user.id,
      body: Faker::Lorem.paragraph(3)
    }
  end
end

victories = Victory.create!(victories_data)

puts 'Seeds: done'