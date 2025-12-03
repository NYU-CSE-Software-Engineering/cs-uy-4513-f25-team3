class AddLocationToItineraryGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :itinerary_groups, :location, :string
  end
end
