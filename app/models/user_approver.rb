class UserApprover < ApplicationRecord
  belongs_to :user
  belongs_to :approver, class_name: 'User', foreign_key: :approver_id
  delegate :full_name, :email, to: :approver, allow_nil: true

  has_paper_trail

  MAX_CONTACTS = 10

  # def approver
  #   approver_id.nil? ? nil : User.find(approver_id)
  # end

  def reviewer?
    approver_type == 'reviewer'
  end

  def notifier?
    approver_type == 'notifier'
  end

  # for rails_admin
  def approval_order_enum
      return (1..5).to_a
  end

  def role_id_enum
    ['reviewer', 'notifier']
  end
end
