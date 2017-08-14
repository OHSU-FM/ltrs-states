require 'rails_helper'

RSpec.describe TravelRequestsHelper, type: :helper do
  it '#hf_funding_options returns a list of awards grouped by pi' do
    fs1 = create :funding_source, pi: 'joe'
    fs2 = create :funding_source, pi: 'susan'
    inactive = create :funding_source, start_date: Date.tomorrow

    expect(helper.hf_funding_options).to be_an Array
    expect(helper.hf_funding_options).to eq [[fs1.pi, [fs1.display_name]],
                                             [fs2.pi, [fs2.display_name]]]
    expect(helper.hf_funding_options).not_to include inactive
  end
end
