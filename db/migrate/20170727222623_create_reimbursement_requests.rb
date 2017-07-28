class CreateReimbursementRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :reimbursement_requests, force: :casecade do |t|
      t.string   "form_user",                 limit: 255
      t.string   "form_email",                limit: 255
      t.boolean  "other_fmr_attending",                   default: false
      t.date     "depart_date"
      t.date     "return_date"
      t.integer  "user_id"
      t.boolean  "air_use",                               default: false
      t.boolean  "car_rental",                            default: false
      t.boolean  "meal_host",                             default: false
      t.boolean  "lodging_reimb",                         default: false
      t.boolean  "traveler_mileage_reimb",                default: false
      t.datetime "deleted_at",                            index: true
      t.timestamps
    end
  end
end
