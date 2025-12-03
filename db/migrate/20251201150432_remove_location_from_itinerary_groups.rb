class RemoveLocationFromItineraryGroups < ActiveRecord::Migration[8.0]
  def change
    remove_column :itinerary_groups, :location, :string
  end
end
