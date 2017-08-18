module Concerns::StateEventsHelper

  # Should this record.approval_state be sent the review event?
  #
  # compares state of a request with a user to see if record is in the unopened
  # state and the use is the next_user_approver. if so, return true, else false
  #
  # @param record [LeaveRequest || TravelRequest]
  # @param user [User]
  # @return [Boolean] whether record should be sent review transition
  def hf_transition_to_in_review? record, user
    return false unless record.approval_state.unopened?

    # first, make sure record.user_approvers.map(&:approver).include? user
    ua = record.approval_state.user_approver_for(user); return false if ua.nil?
    ua_count = record.user.user_approvers.count

    # current_user is correct reviewer if record.approval_order == ua.approval_order - 1
    if record.approval_state.approval_order == 0 && record.user.reviewers.first == ua
      true
    elsif record.approval_state.approval_order == ua.approval_order - 1
      true
    else
      false
    end
  end
end
