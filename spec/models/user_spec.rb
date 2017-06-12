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
      expect(@user.full_name).to eq 'hello there'
    end
  end

  describe 'relationships' do
    before(:each) do
      @user = create :user_with_approvers
    end

    it 'user_approvers is a list of references to approver users sorted by approval_order' do
      expect(@user.user_approvers.map(&:approver)).to all be_a User
      # factory creates approvers in backwards order, so  we can test sort here
      expect(@user.user_approvers.map(&:approval_order)).to eq [1, 2]
    end

    it 'destroys user_approvers when record is destroyed' do
      expect{ @user.destroy }.to change(UserApprover, :count).by(-2)
    end

    it 'reviewers is a list of user_approvers with approver_type: reviewer' do
      expect(@user.reviewers.map(&:approver)).to all be_a User
      expect(@user.reviewers.map(&:approver_type)).to all eq 'reviewer'
    end

    it 'notifiers is a list of user_approvers with approver_type: notifier' do
      expect(@user.notifiers.map(&:approver)).to all be_a User
      expect(@user.notifiers.map(&:approver_type)).to all eq 'notifier'
    end
  end
end
