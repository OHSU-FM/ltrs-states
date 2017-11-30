class ReimbursementRequest < ApplicationRecord
  belongs_to :user
  belongs_to :gf_travel_request, class_name: 'GrantFundedTravelRequest',
    foreign_key: 'grant_funded_travel_request_id'

  has_many :user_files, as: :fileable, dependent: :destroy
  has_many :meal_reimbursement_requests, dependent: :destroy
  has_one :approval_state, as: :approvable, dependent: :destroy

  delegate :current_user_approver, :next_user_approver, to: :approval_state

  before_validation :save_ufs, on: :update

  validates_associated :approval_state
  validates_presence_of :depart_date,
    :return_date,
    :form_email,
    :form_user,
    :user
  validate :miles_map_attachment_if_travel_mildage_reimb,
    :exception_app_attachment_if_additional_docs_needed,
    :additional_info_memo_if_additional_info_needed

  accepts_nested_attributes_for :approval_state, allow_destroy: true
  accepts_nested_attributes_for :user_files, allow_destroy: true
  accepts_nested_attributes_for :meal_reimbursement_requests,
    allow_destroy: true

  after_create :build_approval_state
  after_create :build_meal_reimb_requests

  after_update :update_mrrs

  # self.attributes.except ActiveRecord columns such as created_at and
  # conditionally shown fields.
  # used for validation before submission
  USER_ATTRS = [
    "air_use",
    "car_rental",
    "lodging_reimb",
    "traveler_mileage_reimb",
    "meal_host_reimb"
  ]

  has_paper_trail
  acts_as_paranoid

  # use this for research/clinical later
  def form_type
    ''
  end

  def ready_for_submission?
    if itinerary_ufs.empty?
      errors.add(:itinerary_ufs, 'required before submission')
      return false
    end

    if agenda_ufs.empty?
      errors.add(:agenda_ufs, 'required before submission')
      return false
    end

    attributes.slice(*USER_ATTRS).each do |attr, val|
      if val.nil?
        errors.add(:base, "Please answer all questions before submitting")
        return false
      end
    end
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

  def save_ufs
    user_files.each(&:save!)
  end

  def miles_map_attachment_if_travel_mildage_reimb
    if traveler_mileage_reimb == true
      if miles_map_ufs.empty?
        errors.add(:traveler_mileage_reimb, 'Attachment required')
      end
    end
  end

  def additional_info_memo_if_additional_info_needed
    if additional_info_needed == true
      if additional_info_memo.nil? or additional_info_memo.empty?
        errors.add(:additional_info_memo, 'Required')
      end
    end
  end

  def exception_app_attachment_if_additional_docs_needed
    if additional_docs_needed == true
      if exception_apps.empty?
        errors.add(:additional_docs_needed, 'Attachment required')
      end
    end
  end

  def build_approval_state
    ApprovalState.create(user: user, approvable: self)
  end

  def build_meal_reimb_requests
    (depart_date..return_date).each do |d|
      MealReimbursementRequest.create!(reimb_date: d, reimbursement_request: self)
    end
  end

  def update_mrrs
    mrrs = meal_reimbursement_requests

    # delete mrrs outside rr date range
    mrrs.select{ |mrr|
      !(depart_date..return_date).include? mrr.reimb_date
    }.map(&:destroy)

    # delete duplicates
    mrrs.group_by(&:reimb_date).values.each do |vals|
      next unless vals.count > 1
      vals.sort_by!(&:created_at).pop
      vals.each(&:destroy)
    end
  end
end
