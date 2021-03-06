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

ActiveRecord::Schema.define(version: 2021_06_28_140655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "name", default: "", null: false
    t.boolean "main", default: false, null: false
    t.string "cep", default: "", null: false
    t.string "street", default: "", null: false
    t.string "number", default: "", null: false
    t.string "complements"
    t.string "state", default: "", null: false
    t.string "city", default: "", null: false
    t.string "full_address", default: "", null: false
    t.float "latitude"
    t.float "longitude"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "box_items", force: :cascade do |t|
    t.bigint "carrefour_box_id", null: false
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["carrefour_box_id"], name: "index_box_items_on_carrefour_box_id"
  end

  create_table "boxes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "plan_id", null: false
    t.bigint "box_item_id", null: false
    t.string "box_size", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["box_item_id"], name: "index_boxes_on_box_item_id"
    t.index ["plan_id"], name: "index_boxes_on_plan_id"
  end

  create_table "carrefour_boxes", force: :cascade do |t|
    t.string "name"
    t.string "color", default: "", null: false
    t.text "summary", default: "", null: false
    t.text "description", default: "", null: false
    t.jsonb "plans", default: {}, null: false
    t.float "average_rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "plan_id", null: false
    t.string "status", default: "pending", null: false
    t.string "teddy_sku"
    t.integer "amount_cents", default: 0, null: false
    t.string "checkout_session_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_orders_on_plan_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "address_id"
    t.integer "quantity", default: 1, null: false
    t.integer "ship_day", default: 1, null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "BRL", null: false
    t.integer "shipment_cents", default: 0, null: false
    t.string "shipment_currency", default: "BRL", null: false
    t.integer "total_price_cents", default: 0, null: false
    t.string "total_price_currency", default: "BRL", null: false
    t.boolean "carrefour_card", default: false, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_id"], name: "index_plans_on_address_id"
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "reviews", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "carrefour_box_id", null: false
    t.uuid "user_id", null: false
    t.integer "rating", default: 0, null: false
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["carrefour_box_id"], name: "index_reviews_on_carrefour_box_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "shipments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "plan_id"
    t.string "shipping_code", default: "", null: false
    t.integer "shipping_cost_cents", default: 0, null: false
    t.string "shipping_cost_currency", default: "BRL", null: false
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
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "box_items", "carrefour_boxes"
  add_foreign_key "boxes", "box_items"
  add_foreign_key "boxes", "plans"
  add_foreign_key "orders", "plans"
  add_foreign_key "orders", "users"
  add_foreign_key "plans", "addresses"
  add_foreign_key "plans", "users"
  add_foreign_key "reviews", "carrefour_boxes"
  add_foreign_key "reviews", "users"
  add_foreign_key "shipments", "plans"
end
