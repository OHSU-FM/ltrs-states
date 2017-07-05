class User < ApplicationRecord
  has_many :approval_states
  has_many :user_approvers, -> { order('approval_order ASC') },
    dependent: :destroy

  has_many :leave_requests, through: :approval_states,
    source: :approvable, source_type: "LeaveRequest"
  has_many :travel_requests, through: :approval_states,
    source: :approvable, source_type: "TravelRequest"

  has_many :user_delegations, dependent: :delete_all, inverse_of: :user

  # users we've delegated control to
  has_many :delegates, through: :user_delegations,
    source: :delegate_user, foreign_key: :delegate_user_id

  # users who've delegated control to us
  has_and_belongs_to_many :delegators, join_table: :user_delegations,
    foreign_key: :delegate_user_id,
    association_foreign_key: :user_id,
    class_name: 'User'

  accepts_nested_attributes_for :user_approvers, allow_destroy: true
  accepts_nested_attributes_for :user_delegations, allow_destroy: true

  validates_presence_of :login, :first_name, :last_name, :email

  devise :database_authenticatable, :ldap_authenticatable, :rememberable,
    :trackable, :timeoutable

  has_paper_trail
  acts_as_paranoid

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

  def reviewables
    [reviewable_users.map(&:leave_requests) + reviewable_users.map(&:travel_requests)].flatten
  end

  # cancancan utility functions

  # @return Array[User] users that this user is able to control
  def controllable_users
    @controllable_users ||= ([self] + delegators).uniq
  end

  # @return Array[User] users that this user is able to view
  # def viewable_users
  #   @viewable_users ||=
  # end

  # @return Array[User] users that this user is able to review
  def reviewable_users
    ru = UserApprover.where(approver_id: id,
                            approver_type: 'reviewer').map(&:user)
    @reviewable_users ||= (controllable_users + ru).flatten.uniq
  end

  # @return Array[User] users that this user is notified about
  def notifiable_users
    nu = UserApprover.where(approver_id: id,
                            approver_type: 'notifier').map(&:user)
    @notifiable_users ||= (controllable_users + nu).flatten.uniq
  end
end
