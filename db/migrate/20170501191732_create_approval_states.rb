class CreateApprovalStates < ActiveRecord::Migration[5.1]
  def change
    create_table :approval_states do |t|

      t.timestamps
    end
  end
end
