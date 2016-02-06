require 'database_cleaner'

puts 'Seeds: start'

puts 'Cleaning the database...'

DatabaseCleaner.clean_with(:truncation)

puts 'Creating users...'

users_data = 30.times.with_object([]) do |n, users_data|
  users_data << {
    email: "user#{ n }@example.com",
    nickname: "#{Faker::Internet.user_name}_#{ n }",
    password: 'password',
    confirmed_at: Time.zone.now
  }
end

users = User.create!(users_data)

puts 'Creating victories...'

victories_data = users.each.with_object([]) do |user, victories_data|
  2.times do
    victories_data << {
      user_id: user.id,
      body: Faker::Lorem.paragraph(3)
    }
  end
end

victories = Victory.create!(victories_data)

puts 'Creating votes...'

votes_data = victories.each_with_object([]) do |victory, votes_data|
  users.sample(15).each do |user|
    votes_data << { user: user, victory: victory, value: [1, -1].sample }
  end
end

Vote.create!(votes_data)

puts 'Seeds: done'