class UserMailer < ApplicationMailer

  def request_submitted(approval_state, opts={})
    # byebug
    mail to: approval_state.user.email, subject: 'Instructions'
  end
end
