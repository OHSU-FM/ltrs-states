class UserApprover < ApplicationRecord
  belongs_to :user

  def approver
    User.find(approver_id)
  end
end