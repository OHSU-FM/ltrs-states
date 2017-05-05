class LeaveRequest < ApplicationRecord
  belongs_to :user

  # have to do this in an after_create callback so we have an approvable_id
  # to reference
  after_create :build_approval_state

  # checks the presence of some attributes and returns true if they're there
  # @return [Boolean] true if attributes present, else false
  def ready_for_submission?
    # TODO impl
    true
  end

  def approval_state
    ApprovalState.find_by(approvable: self)
  end

  private

  def build_approval_state
    ApprovalState.create(user: user, approvable: self)
  end
end
