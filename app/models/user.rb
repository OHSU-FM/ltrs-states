class User < ApplicationRecord
  has_many :approval_states
  has_many :user_approvers, -> { order('approval_order ASC') },
    dependent: :destroy

  has_many :leave_requests, through: :approval_states,
    source: :approvable, source_type: "LeaveRequest"
  has_many :travel_requests, through: :approval_states,
    source: :approvable, source_type: "TravelRequest"
  has_many :gf_travel_requests, through: :approval_states,
    source: :approvable, source_type: "GrantFundedTravelRequest"
  has_many :reimbursement_requests, through: :approval_states,
    source: :approvable, source_type: "ReimbursementRequest"

  has_many :user_delegations, dependent: :delete_all, inverse_of: :user

  # users we've delegated control to
  has_many :delegates, through: :user_delegations,
    source: :delegate_user, foreign_key: :delegate_user_id

  # users who've delegated control to us
  has_and_belongs_to_many :delegators, join_table: :user_delegations,
    foreign_key: :delegate_user_id,
    association_foreign_key: :user_id,
    class_name: 'User'

  has_many :ff_numbers, dependent: :destroy

  accepts_nested_attributes_for :user_approvers, allow_destroy: true
  accepts_nested_attributes_for :user_delegations, allow_destroy: true
  accepts_nested_attributes_for :ff_numbers, allow_destroy: true

  validates_presence_of :login, :first_name, :last_name, :email
  validates :air_seat_pref, inclusion: { in: ['aisle', 'middle', 'window']},
    allow_blank: true
  validates :empid, numericality: { only_integer: true }, allow_blank: true

  devise :database_authenticatable, :ldap_authenticatable, :rememberable,
    :trackable, :timeoutable, :recoverable

  has_paper_trail
  acts_as_paranoid

  TRAVEL_PROFILE_ATTRS = [
    :dob,
    :cell_number,
    :ecn1,
    :ecp1,
    :ecn2,
    :ecp2,
    :dietary_restrictions,
    :ada_accom,
    :air_seat_pref,
    :hotel_room_pref,
    :tsa_pre,
    :legal_name,
    :ff_numbers
  ]

  FORM_TRAVEL_PROFILE_ATTRS = [
    :air_seat_pref,
    :tsa_pre,
    :cell_number,
    :drivers_licence_num,
    :ff_numbers
  ]


  # don't let rails_admin count against code coverage
  # :nocov:
  rails_admin do
    edit do
      group 'User Information' do
        field :first_name
        field :last_name
        field :empid
        field :emp_class
        field :emp_home
        field :email
        field :login
        field :is_admin
        field :is_ldap
        field :grant_funded
        field :password do
          hide
        end
        field :password_confirmation do
          hide
        end
        field :timezone
      end

      group 'Traveler Profile' do
        active false
        field :dob
        field :cell_number
        field :ecn1 do
          label 'Emergency Contact Name 1'
        end
        field :ecp1 do
          label 'Emergency Contact Phone 1'
        end
        field :ecn2 do
          label 'Emergency Contact Name 2'
        end
        field :ecp2 do
          label 'Emergency Contact Phone 2'
        end
        field :dietary_restrictions
        field :ada_accom do
          label 'ADA Accommodations'
        end
        field :air_seat_pref, :enum do
          label 'Air Seat Preference'
          enum do
            ['aisle', 'middle', 'window']
          end
        end
        field :hotel_room_pref do
          label 'Hotel Room Preference'
        end
        field :drivers_licence_num do
          label "Driver's license number"
        end
        field :tsa_pre do
          label 'TSA Precheck #'
        end
        field :legal_name
        field :ff_numbers do
          label 'Frequent Flier #s'
        end
      end

      group 'Notifications Config' do
        active false
        field :user_approvers do
          label 'User Contacts'
        end
        field :user_delegations do
          hide
        end
        field :delegates do
          help 'Users this user has delegated control to'
        end
        field :delegators do
          help 'Users who have delegated control to this user'
        end
        field :approval_states do
          hide
        end
      end

      group 'Forms' do
        active false
        field :leave_requests
        field :travel_requests
        field :gf_travel_requests
        field :reimbursement_requests
      end

      group 'Login History' do
        active false
        field :sign_in_count
        field :current_sign_in_at
        field :last_sign_in_at
        field :current_sign_in_ip
        field :last_sign_in_ip
        field :remember_created_at
        field :reset_password_sent_at
      end

      include_all_fields
    end

    list do
      scopes [nil, :deleted]
    end
  end
  # :nocov:

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
  alias :name :full_name

  def reviewers
    user_approvers.where(approver_type: 'reviewer')
  end

  def notifiers
    user_approvers.where(approver_type: 'notifier')
  end

  def has_delegators?
    delegators.count > 0
  end

  def approvables
    (leave_requests + travel_requests + gf_travel_requests + reimbursement_requests)
      .sort_by {|r| r.updated_at }.reverse
  end

  def reviewables
    ApprovalSearch.by_params(self, { filter: 'none' })
  end

  # no defined filter -> !%{unsubmitted complete}
  def active_reviewables
    ApprovalSearch.by_params self
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

  def travel_profile
    h = {}
    TRAVEL_PROFILE_ATTRS.each do |attr|
      h[attr.to_s] = send(attr)
    end
    return h
  end

  def form_travel_profile
    h = {}
    FORM_TRAVEL_PROFILE_ATTRS.each do |attr|
      h[attr.to_s] = send(attr)
    end
    return h
  end

  def lnfi
    "#{last_name.gsub(/\s+/, "")}#{first_name[0]}"
  end
end
