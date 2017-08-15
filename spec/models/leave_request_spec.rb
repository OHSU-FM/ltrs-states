require 'rails_helper'

RSpec.describe LeaveRequest, type: :model do
  it 'has a factory' do
    expect(create :leave_request).to be_valid
  end

  it 'initializes an approval_state after creation' do
    expect((create :leave_request).approval_state).to be_an ApprovalState
  end

  it 'destroys dependent approval_state on delete' do
    lr = create :leave_request
    expect{ lr.destroy }.to change{ ApprovalState.count }.by(-1)
  end

  describe 'validations' do
    it 'requires a user' do
      expect(build :leave_request, user: nil).not_to be_valid
    end

    it 'must have hours of some sort' do
      expect(build :leave_request, hours_vacation: 0, hours_sick: 0,
             hours_other: 0, hours_training: 0, hours_comp: 0,
             hours_cme: 0).not_to be_valid
    end

    it 'must have a start_date' do
      expect(build :leave_request, start_date: nil).not_to be_valid
    end

    it 'must have an end_date' do
      expect(build :leave_request, end_date: nil).not_to be_valid
    end

    it 'must have dates that make sense' do
      bad_start = DateTime.now.tomorrow.to_date
      bad_end = DateTime.now
      expect(build :leave_request, start_date: bad_start, end_date: bad_end)
        .not_to be_valid
    end
  end

  describe 'methods' do
    it '#to_s returns a string representation of the object' do
      lr = create :leave_request
      expect(lr.to_s).to eq "LeaveRequest #{lr.id}"
    end
  end
end
