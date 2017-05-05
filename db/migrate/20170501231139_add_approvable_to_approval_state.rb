class AddApprovableToApprovalState < ActiveRecord::Migration[5.1]
  def change
    add_reference :approval_states, :approvable, polymorphic: true
  end
end
