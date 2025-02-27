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

ActiveRecord::Schema[8.0].define(version: 2025_02_27_224750) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "installment_fees", force: :cascade do |t|
    t.integer "installments", null: false
    t.decimal "fee_percentage", precision: 5, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "receivables", force: :cascade do |t|
    t.bigint "transaction_id", null: false
    t.integer "installment_number", null: false
    t.date "schedule_date", null: false
    t.date "liquidation_date"
    t.string "status", default: "pending", null: false
    t.datetime "pending_at"
    t.datetime "settled_at"
    t.decimal "amount_to_settle", precision: 10, scale: 2, null: false
    t.decimal "amount_settled", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_id"], name: "index_receivables_on_transaction_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.integer "installment", null: false
    t.string "payment_method", null: false
    t.string "status", null: false
    t.datetime "approved_at"
    t.datetime "reproved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "receivables", "transactions"
end
