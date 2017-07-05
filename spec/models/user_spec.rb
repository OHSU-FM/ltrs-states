require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'must have a login' do
      expect(build(:user, login: nil)).not_to be_valid
    end

    it 'must have a first and last name' do
      expect(build(:user, first_name: nil)).not_to be_valid
      expect(build(:user, last_name: nil)).not_to be_valid
    end

    it 'must have a email' do
      expect(build(:user, email: nil)).not_to be_valid
    end
  end

  describe 'methods' do
    it '#full_name should concat first_name and last_name' do
      @user = create :user, first_name: 'hello', last_name: 'there'
      expect(@user.full_name).to eq 'hello there'
    end

    it '#is_reviewer? checks if user is reviewer for any user' do
      user = create :user_with_approvers
      reviewer = user.reviewers.first.approver

      expect(reviewer.is_reviewer?).to be_truthy
    end
  end

  describe 'relationships' do
    before(:each) do
      @user = create :user_with_approvers
    end

    it '#user_approvers is a list of references to approver users sorted by approval_order' do
      expect(@user.user_approvers.map(&:approver)).to all be_a User
      # factory creates approvers in backwards order, so  we can test sort here
      expect(@user.user_approvers.map(&:approval_order)).to eq [1, 2]
    end

    it 'destroys user_approvers when record is destroyed' do
      expect{ @user.destroy }.to change(UserApprover, :count).by(-2)
    end

    it '#reviewers is a list of user_approvers with approver_type: reviewer' do
      expect(@user.reviewers.map(&:approver)).to all be_a User
      expect(@user.reviewers.map(&:approver_type)).to all eq 'reviewer'
    end

    it '#notifiers is a list of user_approvers with approver_type: notifier' do
      expect(@user.notifiers.map(&:approver)).to all be_a User
      expect(@user.notifiers.map(&:approver_type)).to all eq 'notifier'
    end

    it "user should appear in reviewer's #reviewable_users" do
      approver = @user.reviewers.first.approver
      expect(approver.reviewable_users).to include @user
    end

    it "user should appear in notifier's #notifiable_users" do
      approver = @user.notifiers.first.approver
      expect(approver.notifiable_users).to include @user
    end
  end

  describe 'delegation:' do
    it '#user_delegations is a list of user_delegations' do
      user = create :user
      delegate_user = create :user
      user_delegation = create :user_delegation, user: user, delegate_user: delegate_user
      expect(user.user_delegations).to include user_delegation
    end

    it '#delegates is a list of users we have delegated authority to' do
      user = create :user
      delegate_user = create :user
      user_delegation = create :user_delegation, user: user, delegate_user: delegate_user
      expect(user.delegates).to include delegate_user
      expect(delegate_user.delegates).not_to include user
    end

    it '#delegators is a list of users who have delgated authority to us' do
      user = create :user
      delegate_user = create :user
      user_delegation = create :user_delegation, user: user, delegate_user: delegate_user
      expect(delegate_user.delegators).to include user
      expect(user.delegators).not_to include delegate_user
    end

    it "user should appear in delegate user's #controllable_users" do
      user = create :user_with_delegate
      d = user.delegates.first
      expect(d.controllable_users).to include user
    end
  end
end
