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

    it 'should ignore submit -> submit transition and log that it happened' do
      expect(Rails.logger).to receive(:error)
      as = create :leave_approval_state, aasm_state: 'submitted'; as.submit
      e = as.errors
      expect(e.messages[:submit].first)
        .to include "Event 'submit' cannot transition from 'submitted'. "
    end
    # TODO test no mail is sent
  end
end
