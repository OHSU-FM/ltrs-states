class AddGrantFundedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :grant_funded, :boolean
  end
end
