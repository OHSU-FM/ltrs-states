class CreateLeaveRequestExtras < ActiveRecord::Migration[5.1]
  def change
    create_table :leave_request_extras do |t|
      t.integer  "leave_request_id"
      t.integer  "work_days"
      t.decimal  "work_hours",                            precision: 5, scale: 2, default: 0.0
      t.boolean  "basket_coverage"
      t.string   "covering",                  limit: 255
      t.decimal  "hours_professional",                    precision: 5, scale: 2, default: 0.0
      t.text     "hours_professional_desc"
      t.string   "hours_professional_role",   limit: 255
      t.decimal  "hours_administrative",                  precision: 5, scale: 2, default: 0.0
      t.text     "hours_administrative_desc"
      t.string   "hours_administrative_role", limit: 255
      t.boolean  "funding_no_cost"
      t.text     "funding_no_cost_desc"
      t.decimal  "funding_approx_cost"
      t.boolean  "funding_split"
      t.text     "funding_split_desc"
      t.string   "funding_grant",             limit: 255

      t.timestamps
    end
  end
end
