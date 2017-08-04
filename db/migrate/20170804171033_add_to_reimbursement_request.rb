class AddToReimbursementRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :reimbursement_requests, :meal_host_reimb, :boolean
  end
end
