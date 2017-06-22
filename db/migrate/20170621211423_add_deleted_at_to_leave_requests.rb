class AddDeletedAtToLeaveRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :leave_requests, :deleted_at, :datetime
    add_index :leave_requests, :deleted_at
  end
end
