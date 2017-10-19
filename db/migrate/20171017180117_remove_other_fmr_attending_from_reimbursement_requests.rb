class RemoveOtherFmrAttendingFromReimbursementRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :reimbursement_requests, :other_fmr_attending, :boolean
  end
end
