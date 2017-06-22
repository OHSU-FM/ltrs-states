class CreateUserDelegations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_delegations do |t|
      t.belongs_to :user
      t.integer :delegate_user_id
      t.timestamps
    end
  end
end
