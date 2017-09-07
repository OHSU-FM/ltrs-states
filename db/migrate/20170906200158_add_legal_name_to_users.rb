class AddLegalNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :legal_name, :string
  end
end
