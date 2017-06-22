class LeaveRequest < ApplicationRecord
  belongs_to :user
  has_one :approval_state, as: :approvable, dependent: :destroy
  has_one :travel_request
  delegate :next_user_approver, to: :approval_state

  # have to do this in an after_create callback so we have an approvable_id
  # to reference
  after_create :build_approval_state

  has_paper_trail
  acts_as_paranoid

  # checks the presence of some attributes and returns true if they're there
  # @return [Boolean] true if attributes present, else false
  def ready_for_submission?
    # TODO impl
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
end
