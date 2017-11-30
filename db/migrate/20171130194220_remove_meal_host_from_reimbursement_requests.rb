class RemoveMealHostFromReimbursementRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :reimbursement_requests, :meal_host, :boolean, default: nil
  end
end
