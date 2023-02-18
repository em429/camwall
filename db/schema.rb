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

ActiveRecord::Schema[7.0].define(version: 2022_12_25_160507) do
  create_table "cams", force: :cascade do |t|
    t.string "ip"
    t.datetime "shodan_timestamp", precision: nil
    t.string "isp"
    t.string "city"
    t.string "country_name"
    t.string "country_code"
    t.float "longitude"
    t.float "latitude"
    t.text "shodan_response"
    t.integer "port"
    t.binary "screenshot_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "favorite", default: false
    t.string "asn"
    t.string "org"
    t.string "os"
    t.string "screenshot_mime", default: "image/jpeg"
    t.index ["ip"], name: "index_cams_on_ip", unique: true
  end

  create_table "shodan_api_keys", force: :cascade do |t|
    t.string "key"
    t.string "plan"
    t.integer "query_credit_limit"
    t.integer "scan_credit_limit"
    t.integer "monitored_ip_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_shodan_api_keys_on_key", unique: true
  end

end
