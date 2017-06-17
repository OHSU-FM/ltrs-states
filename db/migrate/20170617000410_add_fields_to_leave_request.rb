class AddFieldsToLeaveRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :leave_requests, :form_user, :string, limit: 255
    add_column :leave_requests, :form_email, :string, limit: 255
    add_column :leave_requests, :start_hour, :string, limit: 255
    add_column :leave_requests, :start_min, :string, limit: 255
    add_column :leave_requests, :end_date, :date
    add_column :leave_requests, :end_hour, :string, limit: 255
    add_column :leave_requests, :end_min, :string, limit: 255
    add_column :leave_requests, :desc, :string
    add_column :leave_requests, :hours_vacation, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :leave_requests, :hours_sick, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :leave_requests, :hours_other, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :leave_requests, :hours_other_desc, :string
    add_column :leave_requests, :hours_training, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :leave_requests, :hours_training_desc, :string
    add_column :leave_requests, :hours_comp, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :leave_requests, :hours_comp_desc, :string
    add_column :leave_requests, :hours_cme, :decimal, precision: 5, scale: 2, default: 0.0
    add_column :leave_requests, :has_extra, :boolean
    add_column :leave_requests, :need_travel, :boolean, default: false
    add_column :leave_requests, :mail_sent, :boolean, default: false
    add_column :leave_requests, :mail_final_sent, :boolean, default: false
  end
end
