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
trip_types = ["Escape", "Journey", "Retreat", "Expedition", "Tour", "Getaway", "Experience", "Trip", "Party"]
destinations = [
  "Paris", "Tokyo", "Hawaii", "New York", "Bali", "London", "Boston", "Las Vegas", "Miami",
  "Alaska", "Barcelona", "Sydney", "Rome", "Vancouver", "Iceland", "Netherlands", "spain", "Seoul", "Toronto",
  "New Zealand", "Beijing", "Dubai", "Bangkok", "Istanbul"
]
airlines = ["AA", "DL", "UA", "SW", "BA", "AF"]

puts "Clearing existing data..."

tables = ActiveRecord::Base.connection.tables

ItineraryFlight.destroy_all if tables.include?("itinerary_flights")
ItineraryHotel.destroy_all  if tables.include?("itinerary_hotels")
ItineraryAttendee.destroy_all if tables.include?("itinerary_attendees")
Message.destroy_all if tables.include?("messages")
Flight.destroy_all if tables.include?("flights")
Hotel.destroy_all if tables.include?("hotels")
ItineraryGroup.destroy_all if tables.include?("itinerary_groups")
User.destroy_all if tables.include?("users")


puts "Seeding users..."
# Test login user
User.create!(
  username: "testuser",
  password: "fakepassword",
  password_confirmation: "fakepassword",
  role: "User",
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  age: rand(18..75),
  gender: ["Male", "Female", "Non-binary", "Other"].sample
)

User.create!(
  username: "admin1",
  password: "securepassword",
  password_confirmation: "securepassword",
  role: "Admin",
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  age: rand(25..75),
  gender: ["Male", "Female", "Non-binary", "Other"].sample
)

# Additional fake users
20.times do
  pw = "password123"
  User.create!(
    username: Faker::Internet.unique.username(specifier: 6),
    password: pw,
    password_confirmation: pw,
    role: ["User", "User", "User", "Admin"].sample,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    age: rand(18..80),
    gender: ["Male", "Female", "Non-binary", "Other"].sample
  )
end

puts "Seeding flights..."

300.times do
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
300.times do
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

70.times do
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

puts "Seeding itinerary attendees..."

users = User.all.to_a

ItineraryGroup.find_each do |group|
  # Ensure organizer is also an attendee if present
  if group.organizer_id.present?
    ItineraryAttendee.find_or_create_by!(user_id: group.organizer_id, itinerary_group_id: group.id)
  end

  additional_attendees = users.sample(rand(2..6))
  additional_attendees.each do |user|
    next if user.id == group.organizer_id

    ItineraryAttendee.find_or_create_by!(user_id: user.id, itinerary_group_id: group.id)
  end
end

puts "Seeding itinerary flights and hotels..."

all_flights = Flight.all.to_a
all_hotels = Hotel.all.to_a

ItineraryGroup.find_each do |group|
  # Scope flights and hotels to the itinerary location when possible
  location = group.location
  matching_flights = location.present? ? all_flights.select { |f| f.arrival_location == location } : all_flights
  matching_hotels  = location.present? ? all_hotels.select { |h| h.location == location } : all_hotels

  # Attach 1–3 flights to each itinerary
  matching_flights.sample(rand(1..3)).each do |flight|
    ItineraryFlight.find_or_create_by!(flight_id: flight.id, itinerary_group_id: group.id)
  end

  # Attach 1–2 hotels to each itinerary
  matching_hotels.sample(rand(1..2)).each do |hotel|
    ItineraryHotel.find_or_create_by!(hotel_id: hotel.id, itinerary_group_id: group.id)
  end
end

puts "Seeding messages..."

ItineraryGroup.find_each do |group|
  attendees = ItineraryAttendee.where(itinerary_group_id: group.id).includes(:user).map(&:user)
  next if attendees.empty?

  rand(5..20).times do
    sender = attendees.sample
    sent_time = Faker::Time.between(from: group.start_date.beginning_of_day, to: group.end_date.end_of_day)

    Message.create!(
      user: sender,
      itinerary_group: group,
      text: Faker::Lorem.sentence(word_count: rand(4..16)),
      time: sent_time,
      is_read: [true, false].sample
    )
  end
end

puts "Seeding complete!"
