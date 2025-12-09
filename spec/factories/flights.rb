FactoryBot.define do
  factory :flight do
    sequence(:flight_number) { |n| "FL#{n.to_s.rjust(3, '0')}" }
    departure_location { "New York" }
    arrival_location { "Miami" }
    departure_time { Time.zone.parse("2025-12-04 09:00:00") }
    arrival_time { Time.zone.parse("2025-12-04 13:00:00") }
    cost { 400 }
  end
end

