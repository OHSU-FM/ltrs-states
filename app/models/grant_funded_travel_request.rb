class GrantFundedTravelRequest < ApplicationRecord
  belongs_to :user

  has_many :travel_files, as: :filable, dependent: :destroy
  has_many :user_files, through: :travel_files, dependent: :destroy
  has_one :approval_state, as: :approvable, dependent: :destroy

  delegate :current_user_approver, :next_user_approver, to: :approval_state

  validates_associated :approval_state
  validates_presence_of :depart_date,
    :return_date,
    :form_email,
    :form_user,
    :user
  validate :conference_url
  validate :conference_other
  validate :date_sequence

  accepts_nested_attributes_for :approval_state, allow_destroy: true
  accepts_nested_attributes_for :travel_files, allow_destroy: true
  accepts_nested_attributes_for :user_files, allow_destroy: true

  after_create :build_approval_state

  has_paper_trail
  acts_as_paranoid

  # use this for research/clinical later
  def form_type
    ''
  end

  # TODO impl in the case that there are things to check outside validations
  # checks the presence of some attributes and returns true if they're there
  # @return [Boolean] true if attributes present, else false
  def ready_for_submission?
    true
  end

  def approval_state
    ApprovalState.find_by(approvable: self)
  end

  private

  def build_approval_state
    ApprovalState.create(user: user, approvable: self)
  end

  # validation methods

  def conference_url
    if business_purpose_desc == 'conference' and business_purpose_url.empty?
      errors.add(:business_purpose_url, 'Conference URL must be provided')
    end
  end

  def conference_other
    if business_purpose_desc == 'other' and business_purpose_other.empty?
      errors.add(:business_purpose_other, 'Description must be provided')
    end
  end

  def date_sequence
    if depart_date && return_date && depart_date > return_date
      errors.add(:end_date, '')
      errors.add(:depart_date, 'Beginning of travel cannot be later than end date')
    end
  end
end
