require 'rails_helper'

RSpec.describe GrantFundedTravelRequestsHelper, type: :helper do
  it '#hf_business_purpose_desc_opts is a hash with string keys and values' do
    helper.hf_business_purpose_desc_to_human.each do |k, v|
      expect(k).to be_a String
      expect(v).to be_a String
    end
  end

  describe '#hf_ff_number_enum' do
    context 'when user has delegators' do
      it 'returns []' do
        expect(helper.hf_ff_number_enum(nil)).to eq []
      end
    end

    context 'when user has no delegators' do
      it 'returns a list of the users ff_numbers for select' do
        ffn = create :ff_number
        expect(helper.hf_ff_number_enum([ffn])).to eq [[ffn.airline, ffn.ffid]]
      end
    end
  end
end
