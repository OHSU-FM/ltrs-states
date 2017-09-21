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

ActiveRecord::Schema.define(version: 20170920212957) do

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

  create_table "ff_numbers", force: :cascade do |t|
    t.string "ffid"
    t.string "string"
    t.string "airline"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_ff_numbers_on_user_id"
  end

  create_table "funding_sources", force: :cascade do |t|
    t.string "pi"
    t.string "title"
    t.string "nickname"
    t.string "award_number"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grant_funded_travel_requests", force: :cascade do |t|
    t.string "form_user", limit: 255
    t.string "form_email", limit: 255
    t.boolean "other_fmr_attending"
    t.text "dest_desc"
    t.text "business_purpose_desc"
    t.text "business_purpose_url"
    t.text "business_purpose_other"
    t.date "depart_date"
    t.date "return_date"
    t.boolean "expense_card_use"
    t.string "expense_card_type", limit: 255
    t.boolean "meal_reimb"
    t.boolean "traveler_mileage_reimb"
    t.boolean "traveler_ground_reimb"
    t.boolean "air_use"
    t.boolean "air_assistance"
    t.text "ffid"
    t.text "tsa_pre"
    t.boolean "car_rental"
    t.boolean "car_assistance"
    t.string "cell_number", limit: 255
    t.string "drivers_licence_num", limit: 255
    t.boolean "lodging_reimb"
    t.boolean "lodging_assistance"
    t.string "lodging_url", limit: 255
    t.boolean "registration_reimb"
    t.boolean "registration_assistance"
    t.string "registration_url", limit: 255
    t.integer "user_id"
    t.boolean "mail_sent", default: false
    t.boolean "mail_final_sent", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "rental_needs_desc"
    t.boolean "ground_transport"
    t.boolean "ground_transport_assistance"
    t.text "ground_transport_desc"
    t.string "flight_airline"
    t.string "flight_seat_pref"
    t.index ["deleted_at"], name: "index_grant_funded_travel_requests_on_deleted_at"
  end

  create_table "leave_request_extras", force: :cascade do |t|
    t.integer "leave_request_id"
    t.integer "work_days"
    t.decimal "work_hours", precision: 5, scale: 2, default: "0.0"
    t.boolean "basket_coverage"
    t.string "covering", limit: 255
    t.decimal "hours_professional", precision: 5, scale: 2, default: "0.0"
    t.text "hours_professional_desc"
    t.string "hours_professional_role", limit: 255
    t.decimal "hours_administrative", precision: 5, scale: 2, default: "0.0"
    t.text "hours_administrative_desc"
    t.string "hours_administrative_role", limit: 255
    t.boolean "funding_no_cost"
    t.text "funding_no_cost_desc"
    t.decimal "funding_approx_cost"
    t.boolean "funding_split"
    t.text "funding_split_desc"
    t.string "funding_grant", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leave_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.date "start_date"
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
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_leave_requests_on_deleted_at"
    t.index ["user_id"], name: "index_leave_requests_on_user_id"
  end

  create_table "meal_reimbursement_requests", force: :cascade do |t|
    t.date "reimb_date"
    t.boolean "breakfast"
    t.text "breakfast_desc"
    t.boolean "lunch"
    t.text "lunch_desc"
    t.boolean "dinner"
    t.text "dinner_desc"
    t.bigint "reimbursement_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reimbursement_request_id"], name: "index_meal_reimbursement_requests_on_reimbursement_request_id"
  end

  create_table "reimbursement_requests", force: :cascade do |t|
    t.string "form_user", limit: 255
    t.string "form_email", limit: 255
    t.boolean "other_fmr_attending"
    t.date "depart_date"
    t.date "return_date"
    t.integer "user_id"
    t.boolean "air_use"
    t.boolean "car_rental"
    t.boolean "meal_host"
    t.boolean "lodging_reimb"
    t.boolean "traveler_mileage_reimb"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "meal_host_reimb"
    t.bigint "grant_funded_travel_request_id"
    t.index ["deleted_at"], name: "index_reimbursement_requests_on_deleted_at"
    t.index ["grant_funded_travel_request_id"], name: "index_reimbursement_requests_on_grant_funded_travel_request_id"
  end

  create_table "travel_files", force: :cascade do |t|
    t.bigint "filable_id"
    t.bigint "user_file_id"
    t.string "filable_type"
    t.index ["filable_id"], name: "index_travel_files_on_filable_id"
    t.index ["user_file_id"], name: "index_travel_files_on_user_file_id"
  end

  create_table "travel_requests", force: :cascade do |t|
    t.string "form_user", limit: 255
    t.string "form_email", limit: 255
    t.text "dest_desc"
    t.boolean "air_use", default: false
    t.string "air_desc", limit: 255
    t.text "ffid"
    t.date "dest_depart_date"
    t.string "dest_depart_hour", limit: 255
    t.string "dest_depart_min", limit: 255
    t.string "dest_arrive_hour", limit: 255
    t.string "dest_arrive_min", limit: 255
    t.text "preferred_airline"
    t.text "menu_notes"
    t.integer "additional_travelers"
    t.date "ret_depart_date"
    t.string "ret_depart_hour", limit: 255
    t.string "ret_depart_min", limit: 255
    t.string "ret_arrive_hour", limit: 255
    t.string "ret_arrive_min", limit: 255
    t.text "other_notes"
    t.boolean "car_rental", default: false
    t.date "car_arrive"
    t.string "car_arrive_hour", limit: 255
    t.string "car_arrive_min", limit: 255
    t.date "car_depart"
    t.string "car_depart_hour", limit: 255
    t.string "car_depart_min", limit: 255
    t.text "car_rental_co"
    t.boolean "lodging_use", default: false
    t.text "lodging_card_type"
    t.text "lodging_card_desc"
    t.text "lodging_name"
    t.string "lodging_phone", limit: 255
    t.date "lodging_arrive_date"
    t.date "lodging_depart_date"
    t.text "lodging_additional_people"
    t.text "lodging_other_notes"
    t.boolean "conf_prepayment"
    t.text "conf_desc"
    t.boolean "expense_card_use", default: false
    t.string "expense_card_type", limit: 255
    t.string "expense_card_desc", limit: 255
    t.integer "status", default: 0
    t.integer "user_id"
    t.integer "leave_request_id"
    t.boolean "mail_sent", default: false
    t.boolean "mail_final_sent", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "request_change"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_travel_requests_on_deleted_at"
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

  create_table "user_delegations", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "delegate_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_delegations_on_user_id"
  end

  create_table "user_files", force: :cascade do |t|
    t.string "uploaded_file_name", limit: 255
    t.string "uploaded_file_content_type", limit: 255
    t.integer "uploaded_file_file_size"
    t.datetime "uploaded_file_uploaded_at"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_files_on_user_id"
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
    t.boolean "is_ldap", default: true
    t.datetime "deleted_at"
    t.boolean "grant_funded"
    t.date "dob"
    t.string "cell_number"
    t.string "travel_email"
    t.string "ecn1"
    t.string "ecp1"
    t.string "ecn2"
    t.string "ecp2"
    t.text "dietary_restrictions"
    t.text "ada_accom"
    t.string "air_seat_pref"
    t.text "hotel_room_pref"
    t.string "tsa_pre"
    t.string "legal_name"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "ff_numbers", "users"
  add_foreign_key "reimbursement_requests", "grant_funded_travel_requests"
  add_foreign_key "travel_files", "travel_requests", column: "filable_id"
  add_foreign_key "travel_files", "user_files"
  add_foreign_key "user_approvers", "users"
end
