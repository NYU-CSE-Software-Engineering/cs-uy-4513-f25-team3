FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    sequence(:username) { |n| "user#{n}" }
    password { "password123" }
    role { "user" }
    age { rand(18..70) }
    gender { %w[male female non_binary other].sample }
  end
end
