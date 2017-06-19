class User < ApplicationRecord
  has_many :approval_states
  has_many :user_approvers, -> { order('approval_order ASC') }, dependent: :destroy

  has_many :leave_requests, through: :approval_states,
    source: :approvable, source_type: "LeaveRequest"
  has_many :travel_requests, through: :approval_states,
    source: :approvable, source_type: "TravelRequest"

  validates_presence_of :login

  devise :database_authenticatable, :ldap_authenticatable, :rememberable, :trackable, :timeoutable

  def is_admin?
    is_admin
  end

  def is_reviewer?
    UserApprover.where(approver_id: self.id, approver_type: 'reviewer').count > 0
  end

  def is_ldap?
    is_ldap == true
  end

  def full_name
    "#{ first_name } #{ last_name }"
  end

  def reviewers
    user_approvers.where(approver_type: 'reviewer')
  end

  def notifiers
    user_approvers.where(approver_type: 'notifier')
  end

  def approvables
    leave_requests + travel_requests
  end
end
