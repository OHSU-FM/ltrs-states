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

    it 'renders the correct body' do
      expect(mail.body).to include 'has been submitted'
    end
  end

  describe 'request_rejected' do
    context 'when user has one reviewer' do
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

      it 'renders the correct body' do
        expect(mail.body).to include 'has been rejected'
      end

      it "cc's the user_approvers that have touched the request" do
        leave_request.user.user_approvers.select{ |ua|
          ua.approval_order <= leave_request.approval_state.approval_order
        }.map(&:approver).map(&:email).each do |email|
          expect(mail.cc).to include email
        end
      end
    end

    context 'when user has two reviewers' do
      let(:leave_request) { create :leave_request, :rejected, :two_reviewers }
      let(:mail) { described_class.request_rejected(leave_request.approval_state).deliver_now }

      it "cc's the user_approvers that have touched the request" do
        leave_request.user.user_approvers.select{ |ua|
          ua.approval_order <= leave_request.approval_state.approval_order
        }.map(&:approver).map(&:email).each do |email|
          expect(mail.cc).to include email
        end
      end
    end
  end

  fdescribe 'request_accepted' do
    let(:leave_request) { create :leave_request, :accepted, :two_reviewers }
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

    it 'renders the correct body' do
      expect(mail.body).to include 'has been accepted'
    end

    # TODO send emails to all notifiers
    it "cc's the user's notifier(s)" do
      leave_request.user.notifiers.map{ |ua|
        expect(mail.cc).to include ua.approver.email
      }
    end
  end
end
