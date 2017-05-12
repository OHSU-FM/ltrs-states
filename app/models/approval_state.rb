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

      error do |e|
        errors.add(e.event_name, e.message)
        logger.error(errors[e.event_name].last)
      end
    end

    # TODO get rid of this (use delete and fill in new request from attrs)
    event :unsubmit do
      transitions to: :unsubmitted

      error do |e|
        errors.add(e.event_name, e.message)
        logger.error(errors[e.event_name].last)
      end
    end

    event :reject do
      transitions from: :in_review, to: :rejected

      error do |e|
        errors.add(e.event_name, e.message)
        logger.error(errors[e.event_name].last)
      end
    end
  end

  def log_state_change
    logger.info("changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})")
  end
end
