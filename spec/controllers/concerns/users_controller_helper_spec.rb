require 'rails_helper'

RSpec.describe Concerns::UsersControllerHelper, type: :helper do
  describe 'hf_can_read_profile?' do
    context 'when user is a delegate' do
      let(:usr) { create :complete_user_with_delegate }
      let(:d) { usr.delegates.first }

      it 'returns true when checking a delegators id' do
        expect(helper.hf_can_read_profile?(d, usr.id.to_s)).to be_truthy
      end

      it 'returns true when checking the users id' do
        expect(helper.hf_can_read_profile?(d, d.id.to_s)).to be_truthy
      end

      it 'returns false when checking another id' do
        rando = create :user
        expect(helper.hf_can_read_profile?(d, rando.id.to_s)).to be_falsey
      end
    end
  end
end
