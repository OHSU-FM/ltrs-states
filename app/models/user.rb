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

  rails_admin do
    group 'User Information' do
      field :full_name
      field :empid
      field :emp_class
      field :emp_home
      field :email
      field :login
      field :sn
      field :is_admin
      field :is_ldap
      field :password
      field :password_confirmation
      field :timezone
    end

    group 'Login History' do
      active false
      field :sign_in_count
      field :current_sign_in_at
      field :last_sign_in_at
      field :current_sign_in_ip
      field :last_sign_in_ip
      field :remember_created_at
    end

    group 'Notifications Config' do
      active false
      field :reviewers
      field :others_notified
      field :user_delegations
    end

    group 'Forms' do
      active false
      field :leave_requests
      field :travel_requests
    end

    include_all_fields
    list do
      scopes [nil, :deleted]
    end
  end

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

  def active_reviewables
    reviewables.select{|r| as = r.approval_state; !(as.unsubmitted? or as.is_complete?) }
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

  def reviewable_users_ids
    User.includes(:user_approvers).where(
      ["user_approvers.approver_id = ?
       AND user_approvers.approver_type LIKE 'reviewer'", id]
    ).references(:user_approvers).pluck(:id)
  end

  # @return Array[User] users that this user is able to review
  def reviewable_users
    ru = User.includes(:user_approvers).where(
      ["user_approvers.approver_id = ?
       AND user_approvers.approver_type LIKE 'reviewer'", id]
    ).references(:user_approvers)
    @reviewable_users ||= (controllable_users + ru).flatten.uniq
  end

  # @return Array[User] users that this user is notified about
  def notifiable_users
    nu = User.includes(:user_approvers).where(
      ["user_approvers.approver_id = ?
       AND user_approvers.approver_type LIKE 'notifier'", id]
    ).references(:user_approvers)
    @notifiable_users ||= (controllable_users + nu).flatten.uniq
  end
end
