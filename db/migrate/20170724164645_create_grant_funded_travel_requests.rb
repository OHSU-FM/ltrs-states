class CreateGrantFundedTravelRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :grant_funded_travel_requests, force: :cascade do |t|
      t.string   "form_user",                 limit: 255
      t.string   "form_email",                limit: 255
      t.boolean  "other_fmr_attending",                   default: false
      t.text     "dest_desc"
      t.text     "business_purpose_desc",     limit: 255
      t.text     "business_purpose_url",      limit: 255
      t.text     "business_purpose_other",    limit: 255
      t.date     "depart_date"
      t.date     "return_date"
      t.boolean  "expense_card_use",                      default: false
      t.string   "expense_card_type",         limit: 255
      t.string   "meal_reimb",                limit: 255
      t.boolean  "traveler_mileage_reimb",                default: false
      t.boolean  "traveler_ground_reimb",                 default: false
      t.boolean  "air_use",                               default: false
      t.boolean  "air_assistance",                        default: false
      t.text     "ffid"
      t.text     "tsa_pre"
      t.boolean  "car_rental",                            default: false
      t.boolean  "car_assistance",                        default: false
      t.string   "cell_number",               limit: 255
      t.string   "drivers_licence_num",       limit: 255
      t.boolean  "lodging_reimb",                         default: false
      t.boolean  "lodging_assistance",                    default: false
      t.string   "lodging_url",               limit: 255
      t.boolean  "registration_reimb",                    default: false
      t.boolean  "registration_assistance",               default: false
      t.string   "registration_url",          limit: 255
      t.integer  "user_id"
      t.boolean  "mail_sent",                             default: false
      t.boolean  "mail_final_sent",                       default: false
      t.datetime "deleted_at",                            index: true
      t.timestamps
    end
  end
end
