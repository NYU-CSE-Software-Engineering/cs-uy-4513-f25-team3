# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

trip_adjectives = ["Luxury", "Scenic", "Adventure", "Romantic", "Cultural", "Family", "Solo", "Budget", "Gourmet", "Eco"]
trip_types = ["Escape", "Journey", "Retreat", "Expedition", "Tour", "Getaway", "Experience", "Trip"]
destinations = [
  "Paris", "Tokyo", "Hawaii", "New York", "Bali", "London", "Boston", "Las Vegas", "Miami",
  "Alaska", "Barcelona", "Sydney", "Rome", "Vancouver", "Iceland"
]
airlines = ["AA", "DL", "UA", "SW", "BA", "AF"]

puts "Clearing existing data..."
User.destroy_all
Flight.destroy_all
Hotel.destroy_all
ItineraryGroup.destroy_all
ItineraryAttendee.destroy_all
ItineraryFlight.destroy_all
ItineraryHotel.destroy_all

puts "Seeding users..."
# Test login user
User.create!(
  username: "testuser",
  password: "fakepassword",
  password_confirmation: "fakepassword",
  role: "User"
)

User.create!(
  username: "admin1",
  password: "securepassword",
  password_confirmation: "securepassword",
  role: "Admin"
)

# Additional fake users
10.times do
  pw = "password123"
  User.create!(
    username: Faker::Internet.unique.username(specifier: 6),
    password: pw,
    password_confirmation: pw,
    role: ["User", "User", "User", "Admin"].sample
  )
end

puts "Seeding flights..."

20.times do
  departure_time = Faker::Time.forward(days: rand(5..30), period: :morning)
  arrival_time   = departure_time + rand(2..12).hours

  departure = destinations.sample
  arrival = destinations.sample
  arrival = destinations.sample while arrival == departure

  Flight.create!(
    flight_number: "#{airlines.sample}#{Faker::Number.number(digits: 3)}",
    departure_location: departure,
    arrival_location: arrival,
    departure_time: departure_time,
    arrival_time: arrival_time,
    cost: rand(100.0..1500.0).round(2)
  )
end


puts "Seeding hotels..."
20.times do
  arrival_time   = Faker::Time.forward(days: rand(5..30))
  departure_time = arrival_time + rand(1..10).days + rand(2..12).hours
  place = destinations.sample

  Hotel.create!(
    name: "#{place} #{['Inn', 'Resort', 'Hotel', 'Suites'].sample}",
    location: place,
    rating: rand(1.0..5.0).round(1),
    cost: rand(80.0..600.0).round(2),
    arrival_time: arrival_time,
    departure_time: departure_time
  )
end

puts "Seeding itinerary groups..."

50.times do
  start_date = Faker::Date.forward(days: rand(5..20))
  end_date   = start_date + rand(2..14).days

  place = destinations.sample

  title = "#{trip_adjectives.sample} #{place} #{trip_types.sample}"

  description = [
    "A #{Faker::Adjective.positive} #{trip_types.sample.downcase} exploring",
    "#{Faker::Lorem.words(number: 3).join(' ')}, local culture, and unforgettable sights."
  ].join(" ")

  is_private = [true, false, false, false, false, false].sample

  ItineraryGroup.create!(
    title: title,
    description: description,
    organizer_id: User.pluck(:id).sample,
    start_date: start_date,
    end_date: end_date,
    location: place,
    is_private: is_private,
    cost: rand(300.0..5000.0).round(2),
    password: is_private ? Faker::Internet.password(min_length: 6) : nil
  )
end

puts "Seeding complete!"
