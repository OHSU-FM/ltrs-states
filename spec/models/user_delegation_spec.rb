require 'rails_helper'

RSpec.describe UserDelegation, type: :model do
  describe 'validations' do
    it 'must belong to a user' do
      expect(build(:user_delegation, user: nil)).not_to be_valid
    end

    it 'must reference a delegate' do
      expect(build(:user_delegation, delegate_user: nil)).not_to be_valid
    end
  end
end
