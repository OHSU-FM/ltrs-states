class AddDeletedAtToTravelRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :travel_requests, :deleted_at, :datetime
    add_index :travel_requests, :deleted_at
  end
end
