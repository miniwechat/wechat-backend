# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180721050619) do

  create_table "front_codes", force: :cascade do |t|
    t.string "grant_type"
    t.string "jsCode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scans", force: :cascade do |t|
    t.string "openid"
    t.string "lng_sec"
    t.string "lat_sec"
    t.string "scanTime_sec"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "session_keys", force: :cascade do |t|
    t.string "rdSession"
    t.string "session_key"
    t.string "openId"
    t.string "pubKey"
    t.string "rdSession_key"
    t.string "rdSession_iv"
    t.string "rdSession_final"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
