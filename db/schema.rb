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


ActiveRecord::Schema.define(version: 2021_06_23_180647) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "box_items", force: :cascade do |t|
    t.string "box_name", default: "", null: false
    t.string "item_name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "box_names", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "color", default: "", null: false
    t.text "description", default: "", null: false
  end

  create_table "boxes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "plan_id", null: false
    t.bigint "box_item_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["box_item_id"], name: "index_boxes_on_box_item_id"
    t.index ["plan_id"], name: "index_boxes_on_plan_id"
  end

  create_table "plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "carrefour_card", default: false, null: false
    t.string "category", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "BRL", null: false
    t.integer "shipment_cents", default: 0, null: false
    t.string "shipment_currency", default: "BRL", null: false
    t.uuid "user_id"
    t.boolean "auto_renew", default: true, null: false
    t.integer "quantity", null: false
    t.text "ship_day", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "payment", default: false
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "shipments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "plan_id"
    t.string "shipping_code", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_shipments_on_plan_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.date "birth_date"
    t.string "cpf", default: "", null: false
    t.string "phone", default: "", null: false
    t.string "address", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "boxes", "box_items"
  add_foreign_key "boxes", "plans"
  add_foreign_key "plans", "users"
  add_foreign_key "shipments", "plans"
end
