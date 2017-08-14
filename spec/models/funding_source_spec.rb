require 'rails_helper'

RSpec.describe FundingSource, type: :model do
  it 'has a factory' do
    expect(create :funding_source).to be_valid
  end

  it 'validates title' do
    expect(build :funding_source, title: nil).not_to be_valid
  end

  it 'validates pi' do
    expect(build :funding_source, pi: nil).not_to be_valid
  end

  it 'validates start_date' do
    expect(build :funding_source, start_date: nil).not_to be_valid
  end

  it 'validates end_date' do
    expect(build :funding_source, end_date: nil).not_to be_valid
  end

  it 'validates that start and end dates make sense' do
    expect(build :funding_source, start_date: Date.tomorrow, end_date: Date.yesterday)
      .not_to be_valid
  end

  describe 'scope' do
    it 'active returns only funding_sources where today is between start_date and end_date' do
      active = create :funding_source,
        start_date: Date.yesterday,
        end_date: 2.days.from_now
      inactive = create :funding_source,
        start_date: Date.tomorrow,
        end_date: 2.days.from_now

      expect(FundingSource.active).to include active
      expect(FundingSource.active).not_to include inactive
    end
  end

  it '#display_name concats title and nickname' do
    fs = create :funding_source, title: 'title', nickname: 'nickname'
    expect(fs.display_name).to eq 'title (nickname)'
  end

  it '#display_name doesnt show nickname or parens if nickname.nil?' do
    fs = create :funding_source, title: 'title', nickname: nil
    expect(fs.display_name).to eq 'title'
  end
end
