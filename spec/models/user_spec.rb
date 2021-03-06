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

    it 'empid must be an integer' do
      expect(build(:user, empid: 1.1)).not_to be_valid
      expect(build(:user, empid: 'lol')).not_to be_valid
    end

    it 'air_seat_pref should be one of aisle, middle, window' do
      expect(build :user, air_seat_pref: 'floor').not_to be_valid
      # but it should still be allowed to be nil
      expect(build :user, air_seat_pref: nil).to be_valid
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

    it '#has_delegators? returns true if user has delegators' do
      d = create :user_with_delegate
      u = d.delegates.first

      expect(u.has_delegators?).to be_truthy
    end

    it '#travel_profile' do
      u = create :user_with_profile, ecn1: 'Shia Lebouf'
      expect(u.travel_profile).to be_a Hash
      User::TRAVEL_PROFILE_ATTRS.each do |attr|
        expect(u.travel_profile.keys).to include attr.to_s
      end
      expect(u.travel_profile['ecn1']).to eq 'Shia Lebouf'
    end

    it '#form_travel_profile' do
      u = create :user_with_profile, tsa_pre: '42069'
      expect(u.form_travel_profile).to be_a Hash
      User::FORM_TRAVEL_PROFILE_ATTRS.each do |attr|
        expect(u.form_travel_profile.keys).to include attr.to_s
      end
      expect(u.form_travel_profile['tsa_pre']).to eq '42069'
    end

    it '#lnfi returns last_name plus first initial' do
      u = create :user, last_name: 'Orwell', first_name: 'George'
      expect(u.lnfi).to eq 'OrwellG'
    end

    describe 'reviewer approvables' do
      let(:u) { create :user_with_approvers }
      let(:reviewer) { u.reviewers.first.approver }
      let!(:lr) { create :leave_request, user: u }
      let!(:tr) { create :travel_request, :unopened, user: u }

      it '#reviewables is a list of reviewable requests' do
        expect(reviewer.reviewables).to eq [tr, lr]
      end

      it '#active_reviewables is a list of !%w{unsubmitted complete} requests' do
        expect(reviewer.active_reviewables).to eq [tr]
      end
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
