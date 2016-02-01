Victory.destroy_all
User.destroy_all

5.times do
  User.create!({
    email: Faker::Internet.safe_email,
    nickname: Faker::Internet.user_name
  })
end
