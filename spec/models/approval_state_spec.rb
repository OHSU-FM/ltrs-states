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
    let(:as) { create :leave_approval_state, aasm_state: 'submitted' }

    it 'should transition from submitted to unopened' do
      as.send_to_unopened
      expect(as).to be_unopened
    end

    it 'should only transition from submitted' do
      (ApprovalState.aasm.states.map(&:name) - [:submitted]).each do |state|
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

  describe 'methods' do
    it '#next_approver should return the next reviewer' do
      user = create :user_with_approvers
      state = create :leave_approval_state, user: user, approval_order: 1

      expect(state.next_user_approver).to eq user.user_approvers.first
      state.approval_order = 2; state.save!
      expect(state.next_user_approver).to eq user.user_approvers.second
    end
  end
end
