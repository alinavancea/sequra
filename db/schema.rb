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

ActiveRecord::Schema[8.1].define(version: 2026_02_25_082436) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "disbursements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "merchant_amount", precision: 12, scale: 2, default: "0.0"
    t.uuid "merchant_id", null: false
    t.string "reference"
    t.decimal "sequra_commission", precision: 12, scale: 2, default: "0.0"
    t.decimal "sequra_commission_fee", precision: 10, scale: 4, default: "0.0"
    t.integer "status", default: 0, null: false
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_disbursements_on_merchant_id"
  end

  create_table "merchant_minimum_monthly_commissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "commission_date", null: false
    t.datetime "created_at", null: false
    t.uuid "merchant_id", null: false
    t.decimal "minimum_monthly_commission", precision: 10, scale: 2, default: "0.0"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_merchant_minimum_monthly_commissions_on_merchant_id"
  end

  create_table "merchants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "disbursement_frequency", default: 0, null: false
    t.string "email", null: false
    t.date "last_disbursed_date", default: -> { "CURRENT_TIMESTAMP" }
    t.date "live_on", null: false
    t.decimal "minimum_monthly_fee", precision: 10, scale: 2, default: "0.0"
    t.string "reference", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.uuid "disbursement_id"
    t.string "external_id", null: false
    t.uuid "merchant_id", null: false
    t.date "order_date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["disbursement_id"], name: "index_orders_on_disbursement_id"
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

  add_foreign_key "disbursements", "merchants"
  add_foreign_key "merchant_minimum_monthly_commissions", "merchants"
  add_foreign_key "orders", "disbursements"
  add_foreign_key "orders", "merchants"
end
