class CreateLeaveRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :leave_requests do |t|
      t.references :user, foreign_key: true
      t.datetime :start_date

      t.timestamps
    end
  end
end
