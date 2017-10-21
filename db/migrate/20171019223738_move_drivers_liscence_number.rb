class MoveDriversLiscenceNumber < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :drivers_licence_num, :string, limit: 255
  end
end
