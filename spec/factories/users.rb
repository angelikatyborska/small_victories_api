FactoryGirl.define do
  factory :user do
    sequence(:nickname) { |n| "John#{ n }" }
    sequence(:email) { |n| "user#{ n }@example.com" }
    password 'password'
    confirmed_at { Time.zone.now }
  end
end