class AddDocumentTypeToUserFile < ActiveRecord::Migration[5.1]
  def change
    add_column :user_files, :document_type, :string
  end
end
