class LeaveRequest < ApplicationRecord
  belongs_to :user
  has_one :approval_state, as: :approvable, dependent: :destroy
  has_one :travel_request
  delegate :current_user_approver, :next_user_approver, to: :approval_state

  has_one :leave_request_extra, dependent: :destroy
  accepts_nested_attributes_for :leave_request_extra, allow_destroy: true

  # have to do this in an after_create callback so we have an approvable_id
  # to reference
  after_create :build_approval_state

  has_paper_trail
  acts_as_paranoid

  validates_presence_of :start_date, :end_date
  validate :hours_present
  validate :date_sequence

  # TODO impl in the case that there are things to check outside validations
  # checks the presence of some attributes and returns true if they're there
  # @return [Boolean] true if attributes present, else false
  def ready_for_submission?
    true
  end

  def approval_state
    ApprovalState.find_by(approvable: self)
  end

  def is_traveling
    return (not travel_request.nil? or need_travel)
  end

  # Virtual attribute: returns string stating form type
  def form_type
    has_extra ? 'Faculty' : 'Staff'
  end

  def related_record
    travel_request
  end

  private

  def build_approval_state
    ApprovalState.create(user: user, approvable: self)
  end

  def hours_present
    if (hours_vacation == 0 && hours_sick == 0 && hours_other == 0 &&
        hours_training == 0 && hours_comp == 0 && hours_cme == 0)
      errors.add(:hours_vacation, '')
      errors.add(:hours_sick, '')
      errors.add(:hours_other, '')
      errors.add(:hours_training, '')
      errors.add(:hours_comp, '')
      errors.add(:hours_cme, '')
      errors.add(:base, 'Leave hours: cannot all be blank')
    end
  end

  def date_sequence
    if start_date && end_date && start_date > end_date
      errors.add(:end_date, '')
      errors.add(:start_date, 'Beginning of leave cannot be later than end date')
    end
  end
end
