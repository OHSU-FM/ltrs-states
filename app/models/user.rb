class User < ApplicationRecord
  has_many :approval_states
  has_many :user_approvers, -> { order('approval_order ASC') }, dependent: :destroy

  validates_presence_of :login

  def full_name
    "#{ first_name } #{ last_name }"
  end

  def reviewers
    user_approvers.where(approver_type: 'reviewer')
  end

  def notifiers
    user_approvers.where(approver_type: 'notifier')
  end
end
