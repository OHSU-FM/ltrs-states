class CreateUserApprovers < ActiveRecord::Migration[5.1]
  def change
    create_table :user_approvers do |t|
      t.references :user, foreign_key: true
      t.integer :approver_id
      t.string :approver_type
      t.integer :approval_order

      t.timestamps
    end
  end
end
