class ChangeReimbReq < ActiveRecord::Migration[5.1]
  def up
    remove_column :meal_reimbursement_requests, :breakfast_desc, :text
    remove_column :meal_reimbursement_requests, :lunch_desc, :text
    remove_column :meal_reimbursement_requests, :dinner_desc, :text
    add_column :reimbursement_requests, :meal_na_desc, :text
    add_column :reimbursement_requests, :additional_info_needed, :boolean
    add_column :reimbursement_requests, :additional_info_memo, :text
    add_column :reimbursement_requests, :additional_docs_needed, :boolean
    change_column :users, :dob, 'text USING CAST(dob AS text)'
    remove_column :users, :travel_email
  end

  def down
    add_column :meal_reimbursement_requests, :breakfast_desc, :text
    add_column :meal_reimbursement_requests, :lunch_desc, :text
    add_column :meal_reimbursement_requests, :dinner_desc, :text
    remove_column :reimbursement_requests, :meal_na_desc, :text
    remove_column :reimbursement_requests, :additional_info_needed, :boolean
    remove_column :reimbursement_requests, :additional_info_memo, :text
    remove_column :reimbursement_requests, :additional_docs_needed, :boolean
    change_column :users, :dob, 'date USING dob::date'
    add_column :users, :travel_email, :string
  end
end
