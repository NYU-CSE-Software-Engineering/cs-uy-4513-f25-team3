class CreateItineraryGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :itinerary_groups do |t|
      t.string  :title
      t.string  :description
      t.string  :location
      t.date    :start_date
      t.date    :end_date
      t.boolean :is_private, default: false
      t.integer :organizer_id
      t.float   :cost
      t.string  :password

      t.timestamps
    end
  end
end