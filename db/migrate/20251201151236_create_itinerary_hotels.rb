class CreateItineraryHotels < ActiveRecord::Migration[8.0]
  def change
    create_table :itinerary_hotels do |t|
      t.integer :hotel_id
      t.integer :itinerary_group_id

      t.timestamps
    end
    add_index :itinerary_hotels, [:hotel_id, :itinerary_group_id], unique: true
    add_foreign_key :itinerary_hotels, :hotels
    add_foreign_key :itinerary_hotels, :itinerary_groups
  end
end
