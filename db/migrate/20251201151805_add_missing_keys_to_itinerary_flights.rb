class AddMissingKeysToItineraryFlights < ActiveRecord::Migration[8.0]
  def change
    add_index :itinerary_flights, [:flight_id, :itinerary_group_id],
              unique: true,
              name: "index_itinerary_flights_on_flight_and_group"

    add_foreign_key :itinerary_flights, :flights
    add_foreign_key :itinerary_flights, :itinerary_groups
  end
end