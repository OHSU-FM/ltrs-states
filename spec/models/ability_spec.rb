require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'admin' do
    let(:user) { create :admin }
    let(:second_user) { create :user }

    describe 'actions' do
      it { is_expected.to be_able_to(:manage, user) }
      it { is_expected.to be_able_to(:manage, second_user) }
    end
  end

  describe 'user' do
    let(:user) { create :user_with_approvers }

    describe 'actions' do
      it { is_expected.to be_able_to(:modify, user) }
    end
  end
end
