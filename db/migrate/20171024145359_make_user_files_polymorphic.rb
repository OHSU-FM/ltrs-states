class MakeUserFilesPolymorphic < ActiveRecord::Migration[5.1]
  def change
    add_column :user_files, :fileable_type, :string
    add_column :user_files, :fileable_id, :bigint, foreign_key: true
    remove_column :user_files, :travel_request_id, :bigint
    remove_column :user_files, :grant_funded_travel_request_id, :bigint
  end
end
