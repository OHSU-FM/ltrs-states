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

  describe 'request_rejected' do
    let(:leave_request) { create :leave_request, :rejected }
    let(:mail) { described_class.request_rejected(leave_request.approval_state).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "request rejected"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [leave_request.user.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq ['from@example.com']
    end

    # TODO send emails to all reviewer/notifier who've touched the request
    # previously
    it "cc's the user's first reviewer" do
      expect(mail.cc).to include leave_request.user.user_approvers.first.approver.email
    end
  end

  describe 'request_accepted' do
    let(:leave_request) { create :leave_request, :accepted }
    let(:mail) { described_class.request_accepted(leave_request.approval_state).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "request accepted"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [leave_request.user.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq ['from@example.com']
    end

    # TODO send emails to all notifiers
    it "cc's the user's notifier(s)" do
      expect(mail.cc).to include leave_request.user.user_approvers
        .where(approver_type: 'notifier').map{ |ua|
        ua.approver.email
      }
    end
  end
end
