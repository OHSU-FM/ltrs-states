class ReimbursementRequest < ApplicationRecord
  belongs_to :user
  belongs_to :gf_travel_request, class_name: 'GrantFundedTravelRequest',
    foreign_key: 'grant_funded_travel_request_id'

  has_many :user_files, as: :fileable, dependent: :destroy
  has_many :meal_reimbursement_requests, dependent: :destroy
  has_one :approval_state, as: :approvable, dependent: :destroy

  delegate :current_user_approver, :next_user_approver, to: :approval_state

  validates_associated :approval_state
  validates_presence_of :depart_date,
    :return_date,
    :form_email,
    :form_user,
    :user

  accepts_nested_attributes_for :approval_state, allow_destroy: true
  accepts_nested_attributes_for :user_files, allow_destroy: true
  accepts_nested_attributes_for :meal_reimbursement_requests,
    allow_destroy: true

  after_create :build_approval_state
  after_create :build_meal_reimb_requests

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

  def has_na_meal_reimb?
    meal_reimbursement_requests.any?{|mrr| mrr.has_na? }
  end

  def itinerary_ufs
    user_files.where(document_type: 'Itinerary')
  end

  def agenda_ufs
    user_files.where(document_type: 'Agenda')
  end

  def miles_map_ufs
    user_files.where(document_type: 'MilesMap')
  end

  def exception_apps
    user_files.where(document_type: 'ExceptionApp')
  end

  private

  def build_approval_state
    ApprovalState.create(user: user, approvable: self)
  end

  def build_meal_reimb_requests
    (depart_date..return_date).each do |d|
      MealReimbursementRequest.create!(reimb_date: d, reimbursement_request: self)
    end
  end
end
