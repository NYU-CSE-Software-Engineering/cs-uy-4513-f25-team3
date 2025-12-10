# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_12_10_204548) do
  create_table "flights", force: :cascade do |t|
    t.string "flight_number"
    t.string "departure_location"
    t.string "arrival_location"
    t.datetime "departure_time"
    t.datetime "arrival_time"
    t.float "cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hotels", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.float "rating"
    t.float "cost"
    t.datetime "arrival_time"
    t.datetime "departure_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "itinerary_attendees", force: :cascade do |t|
    t.integer "user_id"
    t.integer "itinerary_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "itinerary_group_id"], name: "index_itinerary_attendees_on_user_id_and_itinerary_group_id", unique: true
  end

  create_table "itinerary_flights", force: :cascade do |t|
    t.integer "flight_id"
    t.integer "itinerary_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flight_id", "itinerary_group_id"], name: "index_itinerary_flights_on_flight_and_group", unique: true
    t.index ["flight_id", "itinerary_group_id"], name: "index_itinerary_flights_on_flight_id_and_itinerary_group_id", unique: true
  end

  create_table "itinerary_groups", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "location"
    t.date "start_date"
    t.date "end_date"
    t.boolean "is_private", default: false
    t.integer "organizer_id"
    t.float "cost"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "itinerary_hotels", force: :cascade do |t|
    t.integer "hotel_id"
    t.integer "itinerary_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id", "itinerary_group_id"], name: "index_itinerary_hotels_on_hotel_id_and_itinerary_group_id", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.integer "user_id"
    t.integer "itinerary_group_id"
    t.string "text"
    t.datetime "time"
    t.boolean "is_read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.integer "age"
    t.string "gender"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "itinerary_attendees", "itinerary_groups"
  add_foreign_key "itinerary_attendees", "users"
  add_foreign_key "itinerary_flights", "flights"
  add_foreign_key "itinerary_flights", "flights"
  add_foreign_key "itinerary_flights", "itinerary_groups"
  add_foreign_key "itinerary_flights", "itinerary_groups"
  add_foreign_key "itinerary_hotels", "hotels"
  add_foreign_key "itinerary_hotels", "itinerary_groups"
end
