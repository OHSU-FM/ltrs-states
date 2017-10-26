class AddAttachmentUploadedFileToUserFiles < ActiveRecord::Migration[5.1]
  def self.up
    change_table :user_files do |t|
      t.attachment :uploaded_file
    end
  end

  def self.down
    remove_attachment :user_files, :uploaded_file
  end
end
