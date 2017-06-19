class ApprovalState < ApplicationRecord
  include AASM

  belongs_to :approvable, polymorphic: true
  belongs_to :user

  aasm do
    state :unsubmitted, initial: true
    state :submitted
    state :unopened
    state :in_review, before_enter: :increment_approval_order
    state :missing_information
    state :rejected
    state :expired
    state :accepted, after_enter: :increment_approval_order
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
      transitions from: [:submitted, :in_review], to: :unopened, guard: :unopened_allowed?

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

  def unopened_allowed?
    next_user_approver.notifier? ? false : true
  end

  def ready_to_submit?
    new_record? == false && approvable.new_record? == false && unsubmitted?
  end

  def is_complete?
    expired? or rejected? or approval_complete?
  end

  def verdict
    if self.is_complete?
      return self.status_str.titleize
    elsif self.ready_to_submit?
      return 'Ready to submit'
    elsif missing_information?
      return "Waiting on response from #{self.user.name || self.user.email} "
    elsif unopened? or in_review?
      return "Waiting on response from #{self.current_user_approver.approver.full_name}"
    elsif next_user_approver.nil?
      return "Error"
    else
      return "Waiting on response from #{next_user_approver.approver.full_name}"
    end
  end
end
