class AddToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :timezone, :string, limit: 255, default: "America/Los_Angeles"
    add_column :users, :empid, :integer
    add_column :users, :emp_class, :string
    add_column :users, :emp_home, :string
  end
end
