class UserMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  add_template_helper(MealReimbursementRequestsHelper)

  def request_submitted(approval_state, opts={})
    logger.info("sending submitted email to: #{approval_state.user.email}, cc: #{approval_state.next_user_approver.approver.email}, record: #{approval_state.approvable.to_s}")
    @approval_state = approval_state
    mail to: approval_state.user.email,
      cc: approval_state.next_user_approver.approver.email,
      subject: "#{@approval_state.approvable.class.to_s.underscore.humanize} submitted",
      template_name: "#{@approval_state.approvable.class.to_s.underscore}_email"
  end

  def request_rejected(approval_state, opts={})
    logger.info("sending rejected email to: #{approval_state.user.email}, cc: #{approval_state.next_user_approver.approver.email}, record: #{approval_state.approvable.to_s}")
    @approval_state = approval_state
    mail to: approval_state.user.email,
      cc: approval_state.current_user_approver.approver.email,
      subject: "#{@approval_state.approvable.class.to_s.underscore.humanize} rejected",
      template_name: "#{@approval_state.approvable.class.to_s.underscore}_email"
  end

  def request_accepted(approval_state, opts={})
    logger.info("sending accepted email to: #{approval_state.user.email}, cc: #{approval_state.next_user_approver.approver.email}, record: #{approval_state.approvable.to_s}")
    @approval_state = approval_state
    mail to: approval_state.user.email,
      cc: approval_state.user.notifiers.map(&:approver).map(&:email),
      subject: "#{@approval_state.approvable.class.to_s.underscore.humanize} accepted",
      template_name: "#{@approval_state.approvable.class.to_s.underscore}_email.html.erb"
  end
end
