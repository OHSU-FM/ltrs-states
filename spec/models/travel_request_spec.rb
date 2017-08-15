require 'rails_helper'

RSpec.describe TravelRequest, type: :model do
  it 'has a factory' do
    expect(build :travel_request).to be_valid
  end

  it 'initializes an approval_state after creation' do
    expect((create :travel_request).approval_state).to be_an ApprovalState
  end

  it 'requires a dest_depart_date' do
    expect(build :travel_request, dest_depart_date: nil).not_to be_valid
  end

  it 'requires a ret_depart_date' do
    expect(build :travel_request, ret_depart_date: nil).not_to be_valid
  end

  it 'requires a form_email' do
    expect(build :travel_request, form_email: nil).not_to be_valid
  end

  it 'requires a form_user' do
    expect(build :travel_request, form_user: nil).not_to be_valid
  end

  it 'requires a user' do
    expect(build :travel_request, user: nil).not_to be_valid
  end

  describe 'methods' do
    it '#to_s returns a string representation of the object' do
      tr = create :travel_request
      expect(tr.to_s).to eq "TravelRequest #{tr.id}"
    end
  end
end
