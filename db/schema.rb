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

ActiveRecord::Schema.define(version: 20170516225544) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "approval_states", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "aasm_state"
    t.bigint "user_id"
    t.string "approvable_type"
    t.bigint "approvable_id"
    t.integer "approval_order"
    t.index ["approvable_type", "approvable_id"], name: "index_approval_states_on_approvable_type_and_approvable_id"
    t.index ["user_id"], name: "index_approval_states_on_user_id"
  end

  create_table "leave_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_leave_requests_on_user_id"
  end

  create_table "user_approvers", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "approver_id"
    t.string "approver_type"
    t.integer "approval_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_approvers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "login", limit: 255, null: false
    t.string "first_name", limit: 255, null: false
    t.string "last_name", limit: 255, null: false
  end

  add_foreign_key "user_approvers", "users"
end
