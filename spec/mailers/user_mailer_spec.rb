require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'request_submitted' do
    let(:leave_request) { create :leave_request, :submitted }
    let(:mail) { described_class.request_submitted(leave_request.approval_state).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "Leave request submitted"
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
      expect(mail.body).to include 'Waiting on response from '
    end
  end

  describe 'request_rejected' do
    context 'when user has one reviewer' do
      let(:leave_request) { create :leave_request, :rejected }
      let(:mail) { described_class.request_rejected(leave_request.approval_state).deliver_now }

      it 'renders the subject' do
        expect(mail.subject).to eq "Leave request rejected"
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq [leave_request.user.email]
      end

      it 'renders the sender email' do
        expect(mail.from).to eq ['from@example.com']
      end

      it 'renders the correct body' do
        expect(mail.body).to include 'Rejected'
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

  describe 'request_accepted' do
    context 'user with one reviewer' do
      let(:leave_request) { create :leave_request, :accepted }
      let(:mail) { described_class.request_accepted(leave_request.approval_state).deliver_now }

      it 'renders the subject' do
        expect(mail.subject).to eq "Leave request accepted"
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq [leave_request.user.email]
      end

      it 'renders the sender email' do
        expect(mail.from).to eq ['from@example.com']
      end

      it 'renders the correct body' do
        expect(mail.body).to include 'Accepted'
      end

      it "cc's the user's notifier(s)" do
        leave_request.user.notifiers.map{ |ua|
          expect(mail.cc).to include ua.approver.email
        }
      end
    end

    context 'user with two reviewers' do
      let(:leave_request) { create :leave_request, :in_review, :two_reviewers }
      before(:each) do
        leave_request.approval_state.send_to_unopened!
        leave_request.approval_state.increment_approval_order
        leave_request.approval_state.review!
        leave_request.approval_state.accept!
      end

      it 'renders the subject' do
        mail = described_class.request_accepted(leave_request.approval_state).deliver_now
        expect(mail.subject).to eq "Leave request accepted"
      end

      it 'renders the receiver email' do
        mail = described_class.request_accepted(leave_request.approval_state).deliver_now
        expect(mail.to).to eq [leave_request.user.email]
      end

      it 'renders the sender email' do
        mail = described_class.request_accepted(leave_request.approval_state).deliver_now
        expect(mail.from).to eq ['from@example.com']
      end

      it 'renders the correct body' do
        mail = described_class.request_accepted(leave_request.approval_state).deliver_now
        expect(mail.body).to include 'Accepted'
      end

      it "cc's the user's notifier(s)" do
        mail = described_class.request_accepted(leave_request.approval_state).deliver_now
        leave_request.user.notifiers.map{ |ua|
          expect(mail.cc).to include ua.approver.email
        }
      end
    end
  end

  describe 'request_first_reviewer_accepted' do
    let(:leave_request) { create :leave_request, :back_to_unopened, :two_reviewers }
    let(:mail) { described_class.request_first_reviewer_accepted(leave_request.approval_state).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq "Leave request accepted by #{leave_request.user.reviewers.first.full_name}"
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [leave_request.user.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq ['from@example.com']
    end

    it 'renders the correct body' do
      expect(mail.body).to include "Waiting on response from #{leave_request.user.reviewers.last.full_name}"
    end

    it "doesn't cc the user's notifier(s)" do
      leave_request.user.notifiers.map{ |ua|
        expect(mail.cc).not_to include ua.approver.email
      }
    end

    it "cc's the user's next_user_approver" do
      expect(mail.cc).to include leave_request.user.reviewers.last.email
    end
  end
end
