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

ActiveRecord::Schema[7.1].define(version: 2026_11_24_221241) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "meeting_events", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.string "midpoint_station_name"
    t.string "midpoint_line_name"
    t.float "midpoint_lat"
    t.float "midpoint_lng"
    t.string "share_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "scheduled_at"
    t.text "note"
    t.index ["share_token"], name: "index_meeting_events_on_share_token", unique: true
    t.index ["user_id"], name: "index_meeting_events_on_user_id"
  end

  create_table "meeting_participants", force: :cascade do |t|
    t.bigint "meeting_event_id", null: false
    t.string "name"
    t.string "station_name"
    t.float "lat"
    t.float "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meeting_event_id"], name: "index_meeting_participants_on_meeting_event_id"
  end

  create_table "members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "station_name"
    t.float "lat"
    t.float "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nearest_station_name"
    t.float "nearest_station_lat"
    t.float "nearest_station_lng"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "meeting_events", "users"
  add_foreign_key "meeting_participants", "meeting_events"
  add_foreign_key "members", "users"
end
