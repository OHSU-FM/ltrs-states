require 'rails_helper'

RSpec.describe Users::ApprovalsController, type: :controller do
  describe 'validation' do
    login_user
    let(:u) { create :user_with_approvers }
    let(:r) { u.reviewers.first.approver }
    let!(:lr) { create :leave_request, :accepted, user: u }
    let!(:tr) { create :travel_request, :submitted, user: u }
    let!(:gftr) { create :gf_travel_request, user: u }

    it 'boots user out if requesting search for another user_id' do
      get :index, params: { user_id: r.id }
      expect(response).to redirect_to root_path
    end
  end
end
