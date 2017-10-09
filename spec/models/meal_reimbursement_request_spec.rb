require 'rails_helper'

RSpec.describe MealReimbursementRequest, type: :model do
  it 'has a factory' do
    expect(create :meal_reimbursement_request).to be_valid
  end

  it 'belongs to a reimbursement request' do
    expect(build :meal_reimbursement_request, reimbursement_request: nil)
      .not_to be_valid
  end

  it 'requires a date' do
    expect(build :meal_reimbursement_request, reimb_date: nil).not_to be_valid
  end

  describe 'methods' do
    it '#has_na?' do
      expect((create :meal_reimbursement_request, breakfast: false).has_na?)
        .to be_truthy
    end
  end
end
