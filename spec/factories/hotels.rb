FactoryBot.define do
  factory :hotel do
    sequence(:name) { |n| "Hotel #{n}" }
    location { Faker::Address.city }
    rating { rand(1..5) }
    arrival_time { Faker::Time.forward(days: 30, period: :afternoon) }
    departure_time { arrival_time + rand(1..10).days }
    cost { rand(80..500) }
  end
end
