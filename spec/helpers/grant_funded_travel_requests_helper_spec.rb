require 'rails_helper'

RSpec.describe GrantFundedTravelRequestsHelper, type: :helper do
  it '#hf_business_purpose_desc_opts is a hash with string keys and values' do
    helper.hf_business_purpose_desc_to_human.each do |k, v|
      expect(k).to be_a String
      expect(v).to be_a String
    end
  end
end
