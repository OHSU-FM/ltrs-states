class AddIsLdapToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_ldap, :boolean, default: true
  end
end
