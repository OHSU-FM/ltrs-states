class LeaveRequest < ApplicationRecord
  belongs_to :user, -> { with_deleted }
  has_one :approval_state, as: :approvable, dependent: :destroy
  delegate :current_user_approver, :next_user_approver, to: :approval_state

  has_one :leave_request_extra, dependent: :destroy
  accepts_nested_attributes_for :leave_request_extra, allow_destroy: true
  # accepts_nested_attributes_for :approval_state

  # have to do this in an after_create callback so we have an approvable_id
  # to reference
  after_create :save_approval_state

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

  # Virtual attribute: returns string stating form type
  def form_type
    has_extra ? 'Faculty' : 'Staff'
  end

  def to_s
    self.class.name + " " + self.id.to_s
  end

  private

  def save_approval_state
    self.create_approval_state(user: user) if approval_state.nil?
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

    unless start_date.nil? or end_date.nil? # nils caught by another validator
      # complain about old dates
      if start_date < Date.new(2010)
        errors.add(:start_date, "That's too far in the past")
      end

      # complain about dates far in the future
      if end_date > Date.new(2050)
        errors.add(:end_date, "That's too far in the future")
      end
    end
  end
end
