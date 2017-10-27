require 'rails_helper'

RSpec.describe UserFile, type: :model do
  describe 'methods' do
    it '#normalize_filename returns a string' do
      u = create :user, first_name: 'Keanu', last_name: 'Reeves'
      gf = create :gf_travel_request, user: u, return_date: '11-12-2043'
      uf = create :user_file, fileable: gf, document_type: 'test'
      expect(uf.normalize_filename).to eq "ReevesK_20431211_#{gf.id}_test.jpg"
    end
  end
end
