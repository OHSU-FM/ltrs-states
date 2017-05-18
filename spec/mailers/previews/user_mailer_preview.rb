# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def request_submitted
    UserMailer.request_submitted(ApprovalState.first)
  end
end
