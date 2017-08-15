require 'rails_helper'

RSpec.describe ReimbursementRequest, type: :model do
  it 'has a factory' do
    expect(build :reimbursement_request).to be_valid
  end

  it 'initializes an approval_state after creation' do
    expect((create :reimbursement_request).approval_state).to be_an ApprovalState
  end

  it 'requires a form_email' do
    expect(build :reimbursement_request, form_email: nil).not_to be_valid
  end

  it 'requires a form_user' do
    expect(build :reimbursement_request, form_user: nil).not_to be_valid
  end

  it 'requires a user' do
    expect(build :reimbursement_request, user: nil).not_to be_valid
  end

  it 'requires a depart_date' do
    expect(build :reimbursement_request, depart_date: nil).not_to be_valid
  end

  it 'requires a return_date' do
    expect(build :reimbursement_request, return_date: nil).not_to be_valid
  end

  it 'generates a MealReimbursementRequest for each day of travel' do
    rr = create :reimbursement_request, depart_date: 1.day.ago, return_date: 1.day.from_now
    expect(rr.meal_reimbursement_requests.first).to be_a MealReimbursementRequest
    expect(rr.meal_reimbursement_requests.count).to eq 3
  end

  describe 'methods' do
    it '#to_s returns a string representation of the object' do
      rr = create :reimbursement_request
      expect(rr.to_s).to eq "ReimbursementRequest #{rr.id}"
    end
  end
end
