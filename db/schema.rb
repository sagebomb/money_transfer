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

ActiveRecord::Schema.define(version: 2019_12_14_162003) do

  create_table "accounts", force: :cascade do |t|
    t.string "number"
    t.string "holder_name"
    t.decimal "balance", precision: 8, scale: 2, default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["number"], name: "index_accounts_on_number", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "from_account_id", null: false
    t.integer "to_account_id", null: false
    t.decimal "amount", precision: 8, scale: 2, default: "0.0", null: false
    t.string "state", default: "created"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["from_account_id"], name: "index_transactions_on_from_account_id"
    t.index ["to_account_id"], name: "index_transactions_on_to_account_id"
  end

end
