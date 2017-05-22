class UserMailer < ApplicationMailer

  def request_submitted(approval_state, opts={})
    @approval_state = approval_state
    mail to: approval_state.user.email,
      cc: approval_state.next_user_approver.approver.email,
      subject: 'request submitted'
  end

  def request_rejected(approval_state, opts={})
    @approval_state = approval_state
    mail to: approval_state.user.email,
      cc: approval_state.next_user_approver.approver.email,
      subject: 'request rejected'
  end

  def request_accepted(approval_state, opts={})
    @approval_state = approval_state
    mail to: approval_state.user.email,
      cc: approval_state.next_user_approver.approver.email,
      subject: 'request accepted'
  end
end
