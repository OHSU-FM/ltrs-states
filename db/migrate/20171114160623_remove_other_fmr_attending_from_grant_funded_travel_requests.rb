class RemoveOtherFmrAttendingFromGrantFundedTravelRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :grant_funded_travel_requests, :other_fmr_attending, :boolean
  end
end
