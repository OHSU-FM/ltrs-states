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

ActiveRecord::Schema.define(version: 20170617000410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "approval_states", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "aasm_state"
    t.bigint "user_id"
    t.string "approvable_type"
    t.bigint "approvable_id"
    t.integer "approval_order", default: 0
    t.index ["approvable_type", "approvable_id"], name: "index_approval_states_on_approvable_type_and_approvable_id"
    t.index ["user_id"], name: "index_approval_states_on_user_id"
  end

  create_table "leave_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "form_user", limit: 255
    t.string "form_email", limit: 255
    t.string "start_hour", limit: 255
    t.string "start_min", limit: 255
    t.date "end_date"
    t.string "end_hour", limit: 255
    t.string "end_min", limit: 255
    t.string "desc"
    t.decimal "hours_vacation", precision: 5, scale: 2, default: "0.0"
    t.decimal "hours_sick", precision: 5, scale: 2, default: "0.0"
    t.decimal "hours_other", precision: 5, scale: 2, default: "0.0"
    t.string "hours_other_desc"
    t.decimal "hours_training", precision: 5, scale: 2, default: "0.0"
    t.string "hours_training_desc"
    t.decimal "hours_comp", precision: 5, scale: 2, default: "0.0"
    t.string "hours_comp_desc"
    t.decimal "hours_cme", precision: 5, scale: 2, default: "0.0"
    t.boolean "has_extra"
    t.boolean "need_travel", default: false
    t.boolean "mail_sent", default: false
    t.boolean "mail_final_sent", default: false
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
    t.string "email", default: "", null: false
    t.string "login", limit: 255, null: false
    t.string "first_name", limit: 255, null: false
    t.string "last_name", limit: 255, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin", default: false
    t.string "timezone", limit: 255, default: "America/Los_Angeles"
    t.integer "empid"
    t.string "emp_class"
    t.string "emp_home"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "user_approvers", "users"
end
