class CreateItineraryGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :itinerary_groups do |t|
      t.string :group_name
      t.date :date
      t.string :location
      t.boolean :is_private
      t.integer :organizer_id
      t.string :password

      t.timestamps
    end
  end
end
