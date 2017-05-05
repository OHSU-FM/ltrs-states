class ApprovalState < ApplicationRecord
  include AASM

  belongs_to :approvable, polymorphic: true
  belongs_to :user

  aasm do
    state :unsubmitted, initial: true
    state :submitted
    state :unopened
    state :in_review
    state :missing_information
    state :rejected
    state :expired
    state :accepted
    state :approval_complete
    state :error

    after_all_transitions :log_state_change

    event :submit do
      before do
        approvable.ready_for_submission?
      end

      transitions from: :unsubmitted, to: :submitted
    end
  end

  def log_state_change
    logger.info("changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})")
  end
end
