require 'rails_helper'

RSpec.describe ReimbursementRequestsController, type: :controller do
  describe "GET #index" do
    # there is no reimbursementrequest#index
  end

  describe "GET #show" do
    context 'as user' do
      login_user
      let(:user) { controller.current_user }

      it "assigns the requested reimbursement_request as @reimbursement_request" do
        reimbursement_request = create :reimbursement_request
        get :show, params: {id: reimbursement_request.to_param}
        expect(assigns(:reimbursement_request)).to eq reimbursement_request
      end

      it "assigns the user as @user" do
        reimbursement_request = create :reimbursement_request
        get :show, params: {id: reimbursement_request.to_param}
        expect(assigns(:user)).to eq user
      end
    end

    context 'as reviewer' do
      login_user
      let(:r_user) { controller.current_user }
      let(:user) { create :user_with_approvers, reviewer_user: r_user }
      let(:reimbursement_request) { create :reimbursement_request, :unopened, user: user }

      it "assigns the current_user as @user" do
        get :show, params: { id: reimbursement_request.to_param }
        expect(assigns(:user)).to eq r_user
      end

      it "assigns the requested reimbursement_request as @reimbursement_request" do
        get :show, params: { id: reimbursement_request.to_param }
        expect(assigns(:reimbursement_request)).to eq reimbursement_request
      end

      it "assigns the current_user's user_approvals_path as @back_path" do
        get :show, params: { id: reimbursement_request.to_param }
        expect(assigns(:back_path)).to eq user_approvals_path(r_user)
      end

      it "sends the :review event to the reimbursement_request" do
        get :show, params: { id: reimbursement_request.to_param }
        expect(reimbursement_request.approval_state).to be_in_review
      end
    end
  end

  describe "GET #new" do
    login_user

    it "assigns a new reimbursement_request as @reimbursement_request" do
      get :new
      expect(assigns(:reimbursement_request)).to be_a_new(ReimbursementRequest)
      expect(assigns(:reimbursement_request).form_user).to eq controller.current_user.full_name
      expect(assigns(:reimbursement_request).form_email).to eq controller.current_user.email
    end
  end

  describe "POST #create" do
    context "with valid params" do
      login_user
      let(:user) { controller.current_user }
      let(:valid_attributes) { build(:reimbursement_request, user: user).attributes }

      it "creates a new ReimbursementRequest" do
        expect {
          post :create, params: { reimbursement_request: valid_attributes }
        }.to change(ReimbursementRequest, :count).by(1)
      end

      it "assigns a newly created reimbursement_request as @reimbursement_request" do
        post :create, params: { reimbursement_request: valid_attributes }
        expect(assigns(:reimbursement_request)).to be_a(ReimbursementRequest)
        expect(assigns(:reimbursement_request)).to be_persisted
      end

      it "redirects to the created reimbursement_request" do
        post :create, params: { reimbursement_request: valid_attributes }
        expect(response).to redirect_to(ReimbursementRequest.last)
      end
    end

    context 'with valid params and a delegate user' do
      login_user
      let(:d_user) { controller.current_user }
      let(:user) { create :user }
      let(:delegation) { create :user_delegation, user: user, delegate_user: d_user }
      let(:valid_attributes) { build(:reimbursement_request, user: user).attributes }

      it "creates a new ReimbursementRequest" do
        expect {
          post :create, params: { reimbursement_request: valid_attributes }
        }.to change(ReimbursementRequest, :count).by(1)
      end

      it "form_user should be delegate user's full_name" do
        post :create, params: { reimbursement_request: valid_attributes }
        expect(ReimbursementRequest.last.form_user).to eq controller.current_user.full_name
      end

      it "form_email should be delegate user's email" do
        post :create, params: { reimbursement_request: valid_attributes }
        expect(ReimbursementRequest.last.form_email).to eq controller.current_user.email
      end

      it "#user should not be current_user" do
        post :create, params: { reimbursement_request: valid_attributes }
        expect(ReimbursementRequest.last.user).not_to eq controller.current_user
        expect(ReimbursementRequest.last.user).to eq user
      end
    end

    context "with invalid params" do
      login_user
      let(:invalid_attributes) {
        build(:reimbursement_request).attributes.except("depart_date").merge("depart_date" => nil)
      }

      it "assigns a newly created but unsaved reimbursement_request as @reimbursement_request" do
        post :create, params: { reimbursement_request: invalid_attributes }
        expect(assigns(:reimbursement_request)).to be_a_new(ReimbursementRequest)
      end

      it "re-renders the 'new' template" do
        post :create, params: { reimbursement_request: invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe "DELETE #destroy" do
    login_user
    let(:user) { controller.current_user }
    let!(:reimbursement_request) { create :reimbursement_request, user: user}

    it "destroys the requested reimbursement_request" do
      expect {
        delete :destroy, params: { id: reimbursement_request.to_param }
      }.to change(ReimbursementRequest, :count).by(-1)
    end

    it "redirects to the forms list" do
      delete :destroy, params: { id: reimbursement_request.to_param }
      expect(response).to redirect_to(user_forms_path(user))
    end
  end

  describe "POST accept" do
    login_user
    context "with in_review request" do
      let(:reimbursement_request) { create :reimbursement_request, :in_review }
      let(:approval_state) { reimbursement_request.approval_state }

      it "assigns the reimbursement_request as @approvable" do
        post :accept, params: { id: reimbursement_request.to_param }
        expect(assigns[:approvable]).to be_a(ReimbursementRequest)
        expect(assigns[:approvable]).to eq reimbursement_request
        expect(assigns[:approvable]).to be_persisted
      end

      it "assigns the approval_state as @approval_state" do
        post :accept, params: { id: reimbursement_request.to_param }
        expect(assigns[:approval_state]).to eq approval_state
        expect(assigns[:approval_state]).to be_persisted
      end

      it "sends the accept event to the approval_state" do
        post :accept, params: { id: reimbursement_request.to_param }
        expect(assigns[:approval_state].aasm_state).to eq "accepted"
      end

      it "redirects to the reimbursement_request_path" do
        post :accept, params: { id: reimbursement_request.to_param }
        expect(response).to redirect_to reimbursement_request_path(reimbursement_request)
      end

      it "sends an email" do
        expect { post :accept, params: { id: reimbursement_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "with non-in_review request" do
      let(:u) { create :user_with_approvers }
      let(:reimbursement_request) { create :reimbursement_request, user: u }
      let(:approval_state) { reimbursement_request.approval_state }

      it "redirects to the reimbursement_request" do
        post :accept, params: { id: reimbursement_request.to_param }
        expect(response).to redirect_to reimbursement_request_path(reimbursement_request)
      end

      it "shows an error message" do
        post :accept, params: { id: reimbursement_request.to_param }
        expect(flash[:notice]).not_to be_empty
      end

      it "doesnt send an email" do
        expect { post :accept, params: { id: reimbursement_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end
end
