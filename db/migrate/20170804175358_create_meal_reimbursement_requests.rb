class CreateMealReimbursementRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :meal_reimbursement_requests do |t|
      t.date :reimb_date
      t.boolean :breakfast
      t.text :breakfast_desc
      t.boolean :lunch
      t.text :lunch_desc
      t.boolean :dinner
      t.text :dinner_desc
      t.references :reimbursement_request

      t.timestamps
    end
  end
end
