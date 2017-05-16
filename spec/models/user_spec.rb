require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'must have a login' do
      expect(build(:user, login: nil)).not_to be_valid
    end
  end

  describe 'methods' do
    it '#full_name should concat first_name and last_name' do
      @user = create :user, first_name: 'hello', last_name: 'there'
      expect(@user.full_name).to eq "hello there"
    end
  end

  describe 'relationships' do
    it 'user_approvers is a list of approver users sorted by approval_order' do
      user = create :user, :with_approvers
      # expect(user.user_approvers.map(&:approver)).to eq
      # TODO finish this tomorrow
    end
  end
end
