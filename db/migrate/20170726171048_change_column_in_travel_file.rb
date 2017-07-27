class ChangeColumnInTravelFile < ActiveRecord::Migration[5.1]
  def up
    rename_column :travel_files, :travel_request_id, :filable_id
    add_column :travel_files, :filable_type, :string
  end

  def down
    change_column :travel_files, :filable_id, :travel_request_id
  end
end
