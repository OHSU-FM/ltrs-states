class TravelRequest < ApplicationRecord
  belongs_to :user, -> { with_deleted }

  has_many :travel_files, as: :filable, dependent: :destroy
  has_many :user_files, through: :travel_files, dependent: :destroy
  has_one :approval_state, as: :approvable, dependent: :destroy

  delegate :current_user_approver, :next_user_approver, to: :approval_state

  validates_associated :approval_state
  validates_presence_of :dest_depart_date,
    :ret_depart_date,
    :form_email,
    :form_user,
    :user

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

  def to_s
    self.class.name + " " + self.id.to_s
  end

  private

  def build_approval_state
    ApprovalState.create(user: user, approvable: self)
  end
end
