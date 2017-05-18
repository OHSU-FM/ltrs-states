class AddApprovalOrderToApprovalState < ActiveRecord::Migration[5.1]
  def change
    add_column :approval_states, :approval_order, :integer, default: 0
  end
end
