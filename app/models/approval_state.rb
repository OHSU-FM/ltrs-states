class ApprovalState < ApplicationRecord
  include AASM

  belongs_to :approvable, polymorphic: true
  belongs_to :user

  aasm do
    state :unsubmitted, initial: true
    state :submitted, before_enter: :increment_approval_order
    state :unopened
    state :in_review
    state :missing_information
    state :rejected
    state :expired
    state :accepted, before_enter: :increment_approval_order
    state :approval_complete
    state :error

    after_all_transitions :log_state_change

    event :submit do
      before do
        approvable.ready_for_submission?
      end

      transitions from: :unsubmitted, to: :submitted

      error do |e|
        log_and_raise_error e
      end
    end

    # TODO get rid of this (use delete and fill in new request from attrs)
    event :unsubmit do
      transitions to: :unsubmitted

      error do |e|
        log_and_raise_error e
      end
    end

    event :send_to_unopened do
      transitions from: :submitted, to: :unopened

      error do |e|
        log_and_raise_error e
      end
    end

    event :review do
      transitions from: :unopened, to: :in_review

      error do |e|
        log_and_raise_error e
      end
    end

    event :reject do
      transitions from: :in_review, to: :rejected

      error do |e|
        log_and_raise_error e
      end
    end

    event :accept do
      transitions from: :in_review, to: :accepted

      error do |e|
        log_and_raise_error e
      end
    end
  end

  # AASM utility methods
  def increment_approval_order
    self.approval_order += 1
    save!
  end

  def log_and_raise_error e
    errors.add(e.event_name, e.message)
    logger.error(errors[e.event_name].last)
    raise e
  end

  def log_state_change
    logger.info("changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})")
  end

  def current_user_approver
    user.user_approvers
      .find{|appr| approval_order == appr.approval_order }
  end

  def next_user_approver
    user.user_approvers
      .select{|appr| approval_order < appr.approval_order }.first
  end
end
