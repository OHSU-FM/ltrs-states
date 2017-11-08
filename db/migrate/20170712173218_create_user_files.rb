class CreateUserFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :user_files do |t|
      t.attachment :uploaded_file
      t.references :user
      t.timestamps
    end
  end
end
