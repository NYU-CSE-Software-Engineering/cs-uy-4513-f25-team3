class CreateItineraryAttendees < ActiveRecord::Migration[8.0]
  def change
    create_table :itinerary_attendees do |t|
      t.integer :user_id
      t.integer :itinerary_group_id

      t.timestamps
    end
    add_index :itinerary_attendees, [:user_id, :itinerary_group_id], unique: true
    add_foreign_key :itinerary_attendees, :users, column: :user_id
    add_foreign_key :itinerary_attendees, :itinerary_groups, column: :itinerary_group_id
  end
end
