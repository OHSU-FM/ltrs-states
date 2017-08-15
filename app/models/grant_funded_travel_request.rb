class GrantFundedTravelRequest < ApplicationRecord
  belongs_to :user

  has_many :travel_files, as: :filable, dependent: :destroy
  has_many :user_files, through: :travel_files, dependent: :destroy
  has_one :approval_state, as: :approvable, dependent: :destroy

  delegate :current_user_approver, :next_user_approver, to: :approval_state

  validates_associated :approval_state
  validates :depart_date, :return_date, :form_email, :form_user, :user,
    :dest_desc, :business_purpose_desc,
    presence: true
  validates :expense_card_use, :air_use, :car_rental, :registration_reimb,
    :lodging_reimb, :ground_transport,
    inclusion: { in: [true, false] }
  validate :conference_url, :conference_other, :date_sequence, :expense_card,
    :air_assistance_if_use, :car_assistance_if_rental, :car_details_if_assistance,
    :registration_assistance_if_reimb

  # require user to give registration_url if they request registration_assistance
  validates :registration_url, presence: true, if: Proc.new{ |gf|
    !gf.registration_assistance.nil? and gf.registration_assistance == true }
  # require user to answer lodging_assistance if they will pay for lodging
  validates :lodging_assistance, inclusion: { in: [true, false] },
    if: Proc.new{ |gf| !gf.lodging_reimb.nil? and gf.lodging_reimb == true }
  # require url of lodging if user requests help booking lodging
  validates :lodging_url, presence: true, if: Proc.new{ |gf|
    !gf.lodging_assistance.nil? and gf.lodging_assistance == true }
  # require user to answer ground_transport_assistance if they will pay for ground_transport
  validates :ground_transport_assistance, inclusion: { in: [true, false] },
    if: Proc.new{ |gf| !gf.ground_transport.nil? and gf.ground_transport == true }
  # require description of trasport need if user requests help w ground transit
  validates :ground_transport_desc, presence: true, if: Proc.new{ |gf|
    !gf.ground_transport_assistance.nil? and gf.ground_transport_assistance == true }

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

  # validation methods

  def conference_url
    if business_purpose_desc == 'conference' and (business_purpose_url.nil? or business_purpose_url.empty?)
      errors.add(:business_purpose_url, 'Conference URL must be provided')
    end
  end

  def conference_other
    if business_purpose_desc == 'other' and (business_purpose_other.nil? or business_purpose_other.empty?)
      errors.add(:business_purpose_other, 'Description must be provided')
    end
  end

  def date_sequence
    if depart_date && return_date && depart_date > return_date
      errors.add(:end_date, '')
      errors.add(:depart_date, 'Beginning of travel cannot be later than end date')
    end
  end

  def expense_card
    if expense_card_use == true and (expense_card_type.nil? or expense_card_type.empty?)
      errors.add(:expense_card_type, 'Award must be provided')
    end
  end

  def air_assistance_if_use
    if air_use == true and (air_assistance.nil? or air_assistance.empty?)
      errors.add(:air_assistance, 'Must be answered if traveler is flying')
    end
  end

  def car_assistance_if_rental
    if car_rental == true and (car_assistance.nil? or car_assistance.empty?)
      errors.add(:car_assistance, 'Must be answered if traveler is renting a car')
    end
  end

  def car_details_if_assistance
    if car_assistance == true
      if rental_needs_desc.nil? or rental_needs_desc.empty?
        errors.add(:rental_needs_desc, 'Must be answered if traveler is requesting assistance')
      elsif cell_number.nil? or cell_number.empty?
        errors.add(:cell_number, 'Must be answered if traveler is requesting assistance')
      elsif drivers_licence_num.nil? or drivers_licence_num.empty?
        errors.add(:drivers_licence_num, 'Must be answered if traveler is requesting assistance')
      end
    end
  end

  def registration_assistance_if_reimb
    if registration_reimb == true and (registration_assistance.nil? or registration_assistance.empty?)
        errors.add(:registration_assistance, 'Must be answered if traveler must pay for event registration')
    end
  end
end
