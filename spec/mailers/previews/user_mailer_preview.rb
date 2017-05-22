# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def request_submitted
    UserMailer.request_submitted(ApprovalState.first)
  end

  def request_rejected
    UserMailer.request_rejected(ApprovalState.first)
  end

  def request_accepted
    UserMailer.request_accepted(ApprovalState.first)
  end
end
