class ChangeLeaveRequestDateFormat < ActiveRecord::Migration[5.1]
  def change
    change_column :leave_requests, :start_date, :date
  end
end
