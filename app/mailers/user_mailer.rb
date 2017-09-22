class UserMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  add_template_helper(MealReimbursementRequestsHelper)
  add_template_helper(GrantFundedTravelRequestsHelper)
  include Rails.application.routes.url_helpers

  def request_submitted(approval_state, opts={})
    @approval_state = approval_state
    logger.info("[MAIL] sending submitted email to: #{@approval_state.user.email}, cc: #{@approval_state.next_user_approver.approver.email}, record: #{@approval_state.approvable.to_s}")
    mail to: @approval_state.user.email,
      cc: @approval_state.next_user_approver.approver.email,
      subject: "#{@approval_state.approvable.class.to_s.underscore.humanize} submitted",
      template_name: "#{@approval_state.approvable.class.to_s.underscore}_email"
  end

  def request_rejected(approval_state, opts={})
    @approval_state = approval_state
    logger.info("[MAIL] sending rejected email to: #{@approval_state.user.email}, cc: #{@approval_state.next_user_approver.approver.email}, record: #{@approval_state.approvable.to_s}")
    mail to: @approval_state.user.email,
      cc: @approval_state.current_user_approver.approver.email,
      subject: "#{@approval_state.approvable.class.to_s.underscore.humanize} rejected",
      template_name: "#{@approval_state.approvable.class.to_s.underscore}_email"
  end

  def request_accepted(approval_state, opts={})
    @approval_state = approval_state
    logger.info("[MAIL] sending accepted email to: #{@approval_state.user.email}, cc: #{@approval_state.user.notifiers.map(&:approver).map(&:email)}, record: #{@approval_state.approvable.to_s}")
    mail to: @approval_state.user.email,
      cc: @approval_state.user.notifiers.map(&:approver).map(&:email),
      subject: "#{@approval_state.approvable.class.to_s.underscore.humanize} accepted",
      template_name: "#{@approval_state.approvable.class.to_s.underscore}_email.html.erb"
  end

  def request_first_reviewer_accepted(approval_state, opts={})
    @approval_state = approval_state
    cc_user = @approval_state.next_user_approver.approver
    logger.info("[MAIL] sending accepted email to: #{@approval_state.user.email}, cc: #{cc_user.email}, record: #{@approval_state.approvable.to_s}")
    mail to: @approval_state.user.email,
      cc: cc_user.email,
      subject: "#{@approval_state.approvable.class.to_s.underscore.humanize} accepted by #{@approval_state.current_user_approver.approver.full_name}",
      template_name: "#{@approval_state.approvable.class.to_s.underscore}_email.html.erb"
  end

  def reimbursement_request_available(approval_state)
    @approval_state = approval_state
    mail_params = {
      to: @approval_state.user.email,
      subject: "Reimbursement request available for #{@approval_state.user.full_name}"
    }

    @delegate_email = @approval_state.approvable.form_email if @approval_state.approvable.delegate_submitted?
    mail_params.merge!({cc: @delegate_email }) unless @delegate_email.nil?

    logger.info("[MAIL] sending reimbursement_request_available email to: #{@approval_state.user.email}")
    mail mail_params
  end
end
