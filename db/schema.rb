# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_02_152429) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "songs", id: :serial, force: :cascade do |t|
    t.string "user_id"
    t.string "name"
    t.string "spotify_id"
    t.json "artists"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "album"
    t.integer "seq"
    t.string "itunes_link"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "fb_id"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "gender"
    t.string "uuid"
    t.string "avatar_url"
    t.string "playlist_id"
    t.index ["uuid"], name: "index_users_on_uuid"
  end

end
