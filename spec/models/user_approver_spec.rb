require 'rails_helper'

RSpec.describe UserApprover, type: :model do
  let(:ua) { create :user_approver }

  describe 'validations' do
    it 'requires a user' do
      expect( build(:user_approver, user: nil) ).not_to be_valid
    end
  end
end
