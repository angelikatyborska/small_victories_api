FactoryGirl.define do
  factory :vote do
    association :user
    association :victory
    value { [1, -1].sample }
  end
end