FactoryBot.define do
  factory :hotel do
    sequence(:name) { |n| "Hotel #{n}" }
    location { "New York" }
    rating { 4 }
    arrival_time { Time.zone.parse("2025-12-04 09:00:00") }
    departure_time { Time.zone.parse("2025-12-12 13:00:00") }
    cost { 300 }
  end
end

