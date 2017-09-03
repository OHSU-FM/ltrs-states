class ApprovalState < ApplicationRecord
  include AASM

  belongs_to :approvable, polymorphic: true
  belongs_to :user, -> { with_deleted }

  has_paper_trail

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
      transitions from: [:in_review, :unopened], to: :rejected

      error do |e|
        log_and_raise_error e
      end
    end

    event :accept do
      transitions from: [:in_review, :unopened], to: :accepted

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

  def previous_user_approver
    user.user_approvers
      .find{|appr| approval_order > appr.approval_order }
  end

  def current_user_approver
    user.user_approvers
      .find{|appr| approval_order == appr.approval_order }
  end

  def next_user_approver
    user.user_approvers
      .select{|appr| approval_order < appr.approval_order }.first
  end

  def user_approver_for u
    user.user_approvers.find{|ua| ua.approver == u }
  end

  def unopened_allowed?
    return false if next_user_approver.nil?
    next_user_approver.notifier? ? false : true
  end

  def ready_to_submit?
    new_record? == false && approvable.new_record? == false && unsubmitted?
  end

  def submitted_or_higher?
    !unsubmitted?
  end

  def verdict
    if unsubmitted? or submitted? or unopened?
      if next_user_approver.notifier?
        verdict_for_ua current_user_approver
      else
        verdict_for_ua next_user_approver
      end
    elsif rejected?
      'Rejected'
    else
      verdict_for_ua current_user_approver
    end
  end

  def process_state
    state = {}
    user.reviewers.each do |r|
      state[r] = verdict_for_ua(r)
    end
    state
  end

  private

  def verdict_for_ua ua
    if approval_order < ua.approval_order
      if approval_order > 0 or !unsubmitted?
        return "Waiting on response from #{ua.approver.full_name}"
      else
        return 'Not Started'
      end
    elsif approval_order > ua.approval_order
      return 'Accepted'
    elsif approval_order == ua.approval_order
      if ua.notifier?
        return 'Completed'
      else
        return "Waiting on response from #{ua.approver.full_name}"
      end
    end
  end
end
