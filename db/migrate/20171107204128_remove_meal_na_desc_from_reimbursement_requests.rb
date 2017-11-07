class RemoveMealNaDescFromReimbursementRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :reimbursement_requests, :meal_na_desc, :text
  end
end
