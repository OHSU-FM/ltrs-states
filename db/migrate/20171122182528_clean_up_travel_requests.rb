class CleanUpTravelRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :travel_requests, :request_change, :text
    remove_column :travel_requests, :mail_sent, :boolean, default: false
    remove_column :travel_requests, :mail_final_sent, :boolean, default: false
    remove_column :travel_requests, :leave_request_id, :integer
    remove_column :travel_requests, :status, :integer, default: 0
  end
end
