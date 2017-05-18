require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'request_submitted' do
    let(:leave_request) { create :leave_request, :submitted }
    let(:mail) { described_class.request_submitted(leave_request.approval_state).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "request submitted"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [leave_request.user.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq ['from@example.com']
    end

    it "cc's the user's first reviewer" do
      expect(mail.cc).to include leave_request.user.user_approvers.first.approver.email
    end
  end
end
