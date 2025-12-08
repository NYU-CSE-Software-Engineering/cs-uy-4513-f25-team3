FactoryBot.define do
  factory :flight do
    sequence(:flight_number) { |n| "FL#{n.to_s.rjust(3, '0')}" }
    departure_location { Faker::Address.city }
    arrival_location { Faker::Address.city }
    departure_time { Faker::Time.forward(days: 30, period: :morning) }
    arrival_time { departure_time + rand(1..6).hours }
    cost { rand(100..1_000) }
  end
end
