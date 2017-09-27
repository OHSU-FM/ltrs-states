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
        expect(mail.body).to include 'Complete'
      end

      it "cc's the user's notifier(s)" do
        leave_request.user.notifiers.map{ |ua|
          expect(mail.cc).to include ua.approver.email
        }
      end

      context 'when request is a GrantFundedTravelRequest' do
        let(:request) { create :gf_travel_request, :accepted }
        let(:reimb) { create :reimbursement_request, gf_travel_request: request }
        let(:mail) { described_class.request_accepted(request.approval_state).deliver_now }

        it 'includes a link to the generated reimbursement request' do
          # TODO
        end
      end
    end

    context 'user with two reviewers' do
      let(:leave_request) { create :leave_request, :back_to_unopened, :two_reviewers }
      before(:each) do
        leave_request.approval_state.review!
        leave_request.approval_state.accept!
        @mail = described_class.request_accepted(leave_request.approval_state).deliver_now
      end

      it 'renders the subject' do
        expect(@mail.subject).to eq "Leave request accepted"
      end

      it 'renders the receiver email' do
        expect(@mail.to).to eq [leave_request.user.email]
      end

      it 'renders the sender email' do
        expect(@mail.from).to eq ['from@example.com']
      end

      it 'renders the correct body' do
        expect(@mail.body).to include 'Complete'
      end

      it "cc's the user's notifier(s)" do
        leave_request.user.notifiers.map{ |ua|
          expect(@mail.cc).to include ua.approver.email
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

  describe 'reimbursement_request_available' do
    let(:mail) { described_class.reimbursement_request_available(gf_travel_request.approval_state).deliver_now }

    context 'when user has no delegators' do
      let(:gf_travel_request) { create :gf_travel_request, :accepted, :with_rr }

      it 'renders the subject' do
        expect(mail.subject).to eq "Reimbursement request available for #{gf_travel_request.user.full_name}"
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq [gf_travel_request.user.email]
      end

      it 'renders the sender email' do
        expect(mail.from).to eq ['from@example.com']
      end

      it 'includes a link to the created ReimbursementRequest' do
        expect(mail.body).to have_link('Click here to access the reimbursement request form')
      end

      it "cc's no one if user has no delegators" do
        expect(mail.cc).to be_nil
      end
    end

    context 'when user has delegators' do
      let(:gf_travel_request) { create :delegated_gftr, :with_rr }
      let(:delegate) { gf_travel_request.user.delegates.first }

      it "cc's the users delegates" do
        expect(mail.cc).to include delegate.email
      end
    end
  end
end
