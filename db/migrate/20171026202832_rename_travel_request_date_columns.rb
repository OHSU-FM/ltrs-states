class RenameTravelRequestDateColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :travel_requests, :dest_depart_date, :depart_date
    rename_column :travel_requests, :ret_depart_date, :return_date
  end
end
