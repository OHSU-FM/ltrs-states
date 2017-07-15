class CreateUserFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :user_files do |t|
      t.string :uploaded_file_name, limit: 255
      t.string :uploaded_file_content_type, limit: 255
      t.integer :uploaded_file_file_size
      t.datetime :uploaded_file_uploaded_at
      t.references :user
      t.timestamps
    end
  end
end
