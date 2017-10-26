class RemoveFiles < ActiveRecord::Migration[5.1]
  def change
    drop_table :travel_files
  end
end
