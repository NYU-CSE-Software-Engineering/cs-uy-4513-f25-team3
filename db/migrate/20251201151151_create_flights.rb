class CreateFlights < ActiveRecord::Migration[8.0]
  def change
    create_table :flights do |t|
      t.string :flight_number
      t.string :departure_location
      t.string :arrival_location
      t.datetime :departure_time
      t.datetime :arrival_time
      t.float :cost

      t.timestamps
    end
  end
end
