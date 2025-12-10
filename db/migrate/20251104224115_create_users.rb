class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      # t.integer :user_id removing because it is automatically created
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password
      t.integer :age
      t.string :gender
      t.string :role

      t.timestamps
    end
  end
end
