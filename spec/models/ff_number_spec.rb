require 'rails_helper'

RSpec.describe FfNumber, type: :model do
  it 'has a factory' do
    expect(create :ff_number).to be_valid
  end

  it 'requires an ffid' do
    expect(build :ff_number, ffid: nil).not_to be_valid
  end

  it 'requires an airline' do
    expect(build :ff_number, airline: nil).not_to be_valid
  end
end
