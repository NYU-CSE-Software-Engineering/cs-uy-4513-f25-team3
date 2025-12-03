class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.integer :itinerary_group_id
      t.string :text
      t.datetime :time
      t.boolean :is_read

      t.timestamps
    end
  end
end
