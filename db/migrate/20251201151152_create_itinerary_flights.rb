class CreateItineraryFlights < ActiveRecord::Migration[8.0]
  def change
    create_table :itinerary_flights do |t|
      t.integer :flight_id
      t.integer :itinerary_group_id

      t.timestamps
    end
    add_index :itinerary_flights, [:flight_id, :itinerary_group_id], unique: true
    add_foreign_key :itinerary_flights, :flights
    add_foreign_key :itinerary_flights, :itinerary_groups
  end
end
