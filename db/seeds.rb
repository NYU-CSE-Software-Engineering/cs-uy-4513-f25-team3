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

puts "Clearing existing data..."
User.destroy_all
Flight.destroy_all
Hotel.destroy_all
ItineraryGroup.destroy_all

puts "Seeding users..."
# Test login user
User.create!(
  username: "aa",
  password: "aa",
  password_confirmation: "aa",
  role: "User"
)

# Additional fake users
10.times do
  pw = "password123"
  User.create!(
    username: Faker::Internet.unique.username(specifier: 6),
    password: pw,
    password_confirmation: pw,
    role: ["User", "Admin"].sample
  )
end

puts "Seeding flights..."
20.times do
  Flight.create!(
    flight_number: Faker::Number.number(digits: 5),
    departure_location: Faker::Address.city,
    arrival_location: Faker::Address.city,
    departure_time: Faker::Time.forward(days: 30, period: :morning),
    arrival_time: Faker::Time.forward(days: 30, period: :evening),
    cost: rand(100.0..1500.0).round(2)
  )
end

puts "Seeding hotels..."
20.times do
  Hotel.create!(
    name: "#{Faker::Address.city} #{['Inn', 'Resort', 'Hotel', 'Suites'].sample}",
    location: Faker::Address.city,
    rating: rand(1.0..5.0).round(1),
    cost: rand(80.0..600.0).round(2),
  )
end


puts "Seeding itinerary groups..."
10.times do
  start_date = Faker::Date.forward(days: rand(5..20))
  end_date   = start_date + rand(1..14).days   # stays 1–14 days
  ItineraryGroup.create!(
    title: "#{Faker::Lorem.words(number: 2).map(&:capitalize).join(' ')} Trip",
    description: Faker::Lorem.sentence(word_count: 10),
    organizer_id: User.pluck(:id).sample,
    start_date: start_date,
    end_date: end_date
  )
end

puts "Seeding complete!"
