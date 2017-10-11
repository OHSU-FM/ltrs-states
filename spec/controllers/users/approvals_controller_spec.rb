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

  describe 'reviewer' do
    login_reviewer
    let(:r) { controller.current_user }
    let(:u) { UserApprover.first.user }

    it 'paginates approvables' do
      leave_requests = create_list(:leave_request, 11, :unopened, user: u)
      get :index, params: { user_id: r.to_param }
      expect(assigns(:approvals).count).to eq 10
    end
  end
end
