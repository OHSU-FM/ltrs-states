class GrantFundedTravelRequest < ApplicationRecord
  belongs_to :user

  has_many :travel_files, as: :filable, dependent: :destroy
  has_many :user_files, through: :travel_files, dependent: :destroy
  has_one :approval_state, as: :approvable, dependent: :destroy
  has_one :reimbursement_request

  delegate :current_user_approver, :next_user_approver, to: :approval_state

  validates_associated :approval_state
  validates :depart_date, :return_date, :user, :dest_desc,
    :business_purpose_desc, presence: true
  validates :expense_card_use, :air_use, :car_rental, :registration_reimb,
    :lodging_reimb, :ground_transport,
    inclusion: { in: [true, false] }
  validate :conference_url, :conference_other, :date_sequence, :expense_card,
    :air_assistance_if_use, :car_assistance_if_rental, :car_details_if_assistance,
    :registration_assistance_if_reimb, :registration_url_if_registration_assistance,
    :lodging_url_if_lodging_assistance

  # require user to answer lodging_assistance if they will pay for lodging
  validates :lodging_assistance, inclusion: { in: [true, false] },
    if: Proc.new{ |gf| !gf.lodging_reimb.nil? and gf.lodging_reimb == true }
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

  def delegate_submitted?
    user.email != form_email
  end

  private

  def build_approval_state
    ApprovalState.create(user: user, approvable: self)
  end

  # validation methods

  def conference_url
    if business_purpose_desc == 'conference'
      if business_purpose_url.nil? or business_purpose_url.empty?
        errors.add(:business_purpose_url, 'Conference URL must be provided')
      elsif !uri? business_purpose_url
        errors.add(:business_purpose_url, "\"#{business_purpose_url}\" doesn't look like a URL")
      end
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

  def expense_card
    if expense_card_use == true and ![true, false].include? expense_card_type
      errors.add(:expense_card_type, 'Award must be provided')
    end
  end

  def air_assistance_if_use
    if air_use == true and ![true, false].include? air_assistance
      errors.add(:air_assistance, 'Must be answered if traveler is flying')
    end
  end

  def car_assistance_if_rental
    if car_rental == true and ![true, false].include? car_assistance
      errors.add(:car_assistance, 'Must be answered if traveler is renting a car')
    end
  end

  def car_details_if_assistance
    if car_assistance == true
      if [nil, ""].include? rental_needs_desc
        errors.add(:rental_needs_desc, 'Must be answered if traveler is requesting assistance')
      end
      if [nil, ""].include? cell_number or !is_a_phone_number?(cell_number)
        errors.add(:cell_number, 'Must be a phone number')
      end
      if [nil, ""].include? drivers_licence_num
        errors.add(:drivers_licence_num, 'Must be answered if traveler is requesting assistance')
      end
    end
  end

  def registration_assistance_if_reimb
    if registration_reimb == true and ![true, false].include? registration_assistance
      errors.add(:registration_assistance, 'Must be answered if traveler must pay for event registration')
    end
  end

  # require user to give registration_url if they request registration_assistance
  def registration_url_if_registration_assistance
    if registration_assistance == true
      if registration_url.nil? or registration_url.empty?
        errors.add(:registration_url, 'Registration URL must be provided')
      elsif !uri? registration_url
        errors.add(:registration_url, "\"#{registration_url}\" doesn't look like a URL")
      end
    end
  end

  # require url of lodging if user requests help booking lodging
  def lodging_url_if_lodging_assistance
    if lodging_assistance == true
      if lodging_url.nil? or lodging_url.empty?
        errors.add(:lodging_url, 'Lodging URL must be provided')
      elsif !uri? lodging_url
        errors.add(:lodging_url, "\"#{lodging_url}\" doesn't look like a URL")
      end
    end
  end
  validates :lodging_url, presence: true, if: Proc.new{ |gf|
    !gf.lodging_assistance.nil? and gf.lodging_assistance == true }

  # returns true if the provided str contains a phone number
  # https://stackoverflow.com/questions/31031984/checking-whether-a-string-contains-a-phone-number
  # @param str String [string to be checked]
  # @return Boolean
  def is_a_phone_number? str
    !str.gsub(/\s+/, "").scan(/([^A-Z|^"|^\s]{6,})/i).empty?
  end

  # returns true if provided str is a uri
  # https://stackoverflow.com/questions/5331014/check-if-given-string-is-an-url
  # @param str String [string to be checked]
  # @return Boolean
  def uri? str
    uri = URI.parse str
    %w( http https ).include? uri.scheme
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end
end
