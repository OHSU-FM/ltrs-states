class AddUserIdToApprovalState < ActiveRecord::Migration[5.1]
  def change
    add_reference :approval_states, :user, foreign_key: true
  end
end
