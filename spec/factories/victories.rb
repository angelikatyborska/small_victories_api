FactoryGirl.define do
  factory :victory do
    association(:user)
    body { Faker::Lorem.paragraph(3) }
  end
end