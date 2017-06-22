class CreateTravelRequests < ActiveRecord::Migration[5.1]
  def change
    create_table "travel_requests", force: :cascade do |t|
      t.string   "form_user",                 limit: 255
      t.string   "form_email",                limit: 255
      t.text     "dest_desc"
      t.boolean  "air_use",                               default: false
      t.string   "air_desc",                  limit: 255
      t.text     "ffid"
      t.date     "dest_depart_date"
      t.string   "dest_depart_hour",          limit: 255
      t.string   "dest_depart_min",           limit: 255
      t.string   "dest_arrive_hour",          limit: 255
      t.string   "dest_arrive_min",           limit: 255
      t.text     "preferred_airline"
      t.text     "menu_notes"
      t.integer  "additional_travelers"
      t.date     "ret_depart_date"
      t.string   "ret_depart_hour",           limit: 255
      t.string   "ret_depart_min",            limit: 255
      t.string   "ret_arrive_hour",           limit: 255
      t.string   "ret_arrive_min",            limit: 255
      t.text     "other_notes"
      t.boolean  "car_rental",                            default: false
      t.date     "car_arrive"
      t.string   "car_arrive_hour",           limit: 255
      t.string   "car_arrive_min",            limit: 255
      t.date     "car_depart"
      t.string   "car_depart_hour",           limit: 255
      t.string   "car_depart_min",            limit: 255
      t.text     "car_rental_co"
      t.boolean  "lodging_use",                           default: false
      t.text     "lodging_card_type"
      t.text     "lodging_card_desc"
      t.text     "lodging_name"
      t.string   "lodging_phone",             limit: 255
      t.date     "lodging_arrive_date"
      t.date     "lodging_depart_date"
      t.text     "lodging_additional_people"
      t.text     "lodging_other_notes"
      t.boolean  "conf_prepayment"
      t.text     "conf_desc"
      t.boolean  "expense_card_use",                      default: false
      t.string   "expense_card_type",         limit: 255
      t.string   "expense_card_desc",         limit: 255
      t.integer  "status",                                default: 0
      t.integer  "user_id"
      t.integer  "leave_request_id"
      t.boolean  "mail_sent",                             default: false
      t.boolean  "mail_final_sent",                       default: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "request_change"
    end
  end
end
