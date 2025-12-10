class CreateHotels < ActiveRecord::Migration[8.0]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :location
      t.float :rating
      t.float :cost
      t.datetime :arrival_time
      t.datetime :departure_time

      t.timestamps
    end
  end
end
