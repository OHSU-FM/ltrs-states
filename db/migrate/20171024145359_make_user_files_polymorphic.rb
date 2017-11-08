class MakeUserFilesPolymorphic < ActiveRecord::Migration[5.1]
  def change
    add_column :user_files, :fileable_type, :string
    add_column :user_files, :fileable_id, :bigint, foreign_key: true
  end
end
