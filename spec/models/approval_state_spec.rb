require 'rails_helper'

RSpec.describe ApprovalState, type: :model do
  it 'should have a factory' do
    expect(create :leave_approval_state).to be_valid
  end

  it 'must belong to a user' do
    expect(build :approval_state, user: nil).not_to be_valid
  end

  it 'must belong to an approvable' do
    expect(build :approval_state, approvable: nil).not_to be_valid
  end

  it 'should start with an approval_order of 0' do
    expect(create(:leave_approval_state).approval_order).to eq 0
  end

  describe 'general state behavior' do
    it 'should act as a state machine' do
      expect(ApprovalState.aasm.states).to be_an Array
    end

    it 'should initialize in the unsubmitted state' do
      expect((create :leave_approval_state).aasm_state).to eq 'unsubmitted'
    end

    it 'should log the state change after a transition' do
      as = create :leave_approval_state
      expect(Rails.logger).to receive(:info)
        .with("changing from unsubmitted to submitted (event: submit)")
      as.submit
    end
  end

  describe 'the submit event' do
    let(:as) { create :leave_approval_state }

    it 'should transition from unsubmitted to submitted' do
      as.submit
      expect(as.aasm_state).to eq 'submitted'
    end

    it 'verify presence of required approvable attributes' do
      expect(as.approvable).to receive(:ready_for_submission?)
      as.submit
    end

    it 'should only transition from unsubmitted' do
      (ApprovalState.aasm.states.map(&:name) - [:unsubmitted]).each do |state|
        expect(Rails.logger).to receive(:error)
        expect{
          create(:leave_approval_state, aasm_state: state).submit
        }.to raise_error AASM::InvalidTransition
      end
    end
  end

  describe 'the send_to_unopened event' do
    it 'should transition from submitted to unopened' do
      as = create :leave_approval_state, aasm_state: 'submitted'
      as.send_to_unopened!
      expect(as).to be_unopened
    end

    it 'should not transition from in_review to unopened if next_user_approver is notifier' do
      as = create :leave_approval_state, :in_review
      expect(Rails.logger).to receive(:error)
      expect{ as.send_to_unopened! }.to raise_error AASM::InvalidTransition
      expect(as).to be_in_review
    end

    it 'should transition from in_review to unopened if next_user_approver is reviewer' do
      as = create :leave_approval_state, :in_review, :two_reviewers
      as.send_to_unopened!
      expect(as).to be_unopened
    end

    it 'should only transition from submitted or in_review' do
      (ApprovalState.aasm.states.map(&:name) - [:submitted, :in_review]).each do |state|
        expect(Rails.logger).to receive(:error)
        expect{
          create(:leave_approval_state, aasm_state: state).send_to_unopened
        }.to raise_error AASM::InvalidTransition
      end
    end
  end

  describe 'the review event' do
    let(:as) { create :leave_approval_state, aasm_state: 'unopened' }

    it 'should transition from unopened to in_review' do
      as.review
      expect(as).to be_in_review
    end

    it 'should only transition from in_review' do
      (ApprovalState.aasm.states.map(&:name) - [:unopened]).each do |state|
        expect(Rails.logger).to receive(:error)
        expect{
          create(:leave_approval_state, aasm_state: state).review
        }.to raise_error AASM::InvalidTransition
      end
    end
  end

  describe 'the reject event' do
    let(:as) { create :leave_approval_state, aasm_state: 'in_review' }

    it 'should transition from in_review to rejected' do
      as.reject
      expect(as).to be_rejected
    end

    it 'should only transition from in_review' do
      (ApprovalState.aasm.states.map(&:name) - [:in_review]).each do |state|
        expect(Rails.logger).to receive(:error)
        expect{
          create(:leave_approval_state, aasm_state: state).reject
        }.to raise_error AASM::InvalidTransition
      end
    end
  end

  describe 'the accept event' do
    let(:as) { create :leave_approval_state, aasm_state: 'in_review' }

    it 'should transition from in_review to accepted' do
      as.accept
      expect(as).to be_accepted
    end

    it 'should only transition from in_review' do
      (ApprovalState.aasm.states.map(&:name) - [:in_review]).each do |state|
        expect(Rails.logger).to receive(:error)
        expect{
          create(:leave_approval_state, aasm_state: state).accept
        }.to raise_error AASM::InvalidTransition
      end
    end
  end

  describe 'methods' do
    it '#next_user_approver should return the next reviewer' do
      request = create :leave_request, :in_review
      user = request.user

      expect(request.approval_state.next_user_approver).to eq user.user_approvers.second
    end

    it '#current_user_approver should return the current_user_approver' do
      request = create :leave_request, :in_review
      user = request.user

      expect(request.approval_state.current_user_approver).to eq user.user_approvers.first
    end

    it '#submitted_or_higher? should return true if state has ever been submitted' do
      (ApprovalState.aasm.states.map(&:name) - [:unsubmitted, :missing_information, :expired, :approval_complete, :error]).each do |state|
        request = create :leave_request, state
        expect(request.approval_state.submitted_or_higher?).to be_truthy
      end
    end
  end

  describe 'process_state' do
    context 'one reviewer' do
      before(:each) do
        @user = create :user_with_approvers
        @request = create :leave_request, user: @user
      end

      it "'s keys are the users user_approvers" do
        @request.approval_state.process_state.keys.each do |k|
          expect(@user.user_approvers).to include k
        end
      end

      it "'s values should be a string" do
        @request.approval_state.process_state.values.each do |v|
          expect(v).to be_a String
        end
      end

      it "value for a given approver is 'Not Started' if approval_order is > \
        state approval_order" do
        expect(@request.approval_state.process_state.values.last).to eq 'Not Started'
      end

      # it "'s values should be a phrase that compares a user with what action is \
      #  expected of them for this request" do
      #   expect(@request.approval_state.process_state.values.first).to eq 'unopened'
      # end
    end

    context 'two reviewers' do
      before(:each) do
        @user = create :user_two_reviewers
        @request = create :leave_request, user: @user
      end

      it "value for a given reviewer is 'accepted' if \
        approval_order < state approval order" do
        expect(@request.approval_state.process_state[@user.reviewers.first]).to eq 'accepted'
      end
    end
  end
end
