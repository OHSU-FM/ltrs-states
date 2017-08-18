require 'rails_helper'

RSpec.describe LeaveRequestsController, type: :controller do
  describe "GET #show" do
    context 'as user' do
      login_user
      let(:user) { controller.current_user }
      let(:leave_request) { create :leave_request, user: user }

      it "assigns the current_user as @user" do
        get :show, params: { id: leave_request.to_param }
        expect(assigns(:user)).to eq user
      end

      it "assigns the requested leave_request as @leave_request" do
        get :show, params: { id: leave_request.to_param }
        expect(assigns(:leave_request)).to eq leave_request
      end

      it "assigns the current_user's user_forms_path as @back_path" do
        get :show, params: { id: leave_request.to_param }
        expect(assigns(:back_path)).to eq user_forms_path(user)
      end
    end

    context 'as reviewer' do
      login_user
      let(:r_user) { controller.current_user }
      let(:user) { create :user_with_approvers, reviewer_user: r_user }
      let(:leave_request) { create :leave_request, :unopened, user: user }

      it "assigns the current_user as @user" do
        get :show, params: { id: leave_request.to_param }
        expect(assigns(:user)).to eq r_user
      end

      it "assigns the requested leave_request as @leave_request" do
        get :show, params: { id: leave_request.to_param }
        expect(assigns(:leave_request)).to eq leave_request
      end

      it "assigns the current_user's user_approvals_path as @back_path" do
        get :show, params: { id: leave_request.to_param }
        expect(assigns(:back_path)).to eq user_approvals_path(r_user)
      end

      it "sends the :review event to the leave_request" do
        get :show, params: { id: leave_request.to_param }
        expect(leave_request.approval_state).to be_in_review
      end
    end
  end

  describe "GET #new" do
    login_user
    it "assigns a new leave_request as @leave_request" do
      get :new
      expect(assigns(:leave_request)).to be_a_new(LeaveRequest)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      login_user
      let(:user) { controller.current_user }
      let(:valid_attributes) { build(:leave_request, user: user).attributes }

      it "creates a new LeaveRequest" do
        expect {
          post :create, params: { leave_request: valid_attributes }
        }.to change(LeaveRequest, :count).by(1)
      end

      it "assigns a newly created leave_request as @leave_request" do
        post :create, params: { leave_request: valid_attributes }
        expect(assigns(:leave_request)).to be_a(LeaveRequest)
        expect(assigns(:leave_request)).to be_persisted
      end

      it "redirects to the created leave_request" do
        post :create, params: { leave_request: valid_attributes }
        expect(response).to redirect_to(LeaveRequest.last)
      end

      it "form_user should be the current_user's full_name" do
        post :create, params: { leave_request: valid_attributes }
        expect(LeaveRequest.last.form_user).to eq user.full_name
      end

      it "form_email should be the current_user's email" do
        post :create, params: { leave_request: valid_attributes }
        expect(LeaveRequest.last.form_email).to eq user.email
      end

      it "user should be current_user" do
        post :create, params: { leave_request: valid_attributes }
        expect(LeaveRequest.last.user).to eq controller.current_user
      end
    end

    context "with valid params and a delegate user" do
      login_user
      let(:d_user) { controller.current_user }
      let(:user) { create :user }
      let(:delegation) { create :user_delegation, user: user, delegate_user: d_user }
      let(:valid_attributes) { build(:leave_request, user: user).attributes }

      it "creates a new LeaveRequest" do
        expect {
          post :create, params: { leave_request: valid_attributes }
        }.to change(LeaveRequest, :count).by(1)
      end

      it "form_user should be delegate user's full_name" do
        post :create, params: { leave_request: valid_attributes }
        expect(LeaveRequest.last.form_user).to eq controller.current_user.full_name
      end

      it "form_email should be delegate user's email" do
        post :create, params: { leave_request: valid_attributes }
        expect(LeaveRequest.last.form_email).to eq controller.current_user.email
      end

      it "#user should not be current_user" do
        post :create, params: { leave_request: valid_attributes }
        expect(LeaveRequest.last.user).not_to eq controller.current_user
        expect(LeaveRequest.last.user).to eq user
      end
    end

    context "with invalid params" do
      login_user
      let(:invalid_attributes) {
        build(:leave_request).attributes.except("user_id").merge("user_id" => nil)
      }

      it "assigns a newly created but unsaved leave_request as @leave_request" do
        post :create, params: {leave_request: invalid_attributes}
        expect(assigns(:leave_request)).to be_a_new(LeaveRequest)
      end

      it "re-renders the 'new' template" do
        post :create, params: {leave_request: invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "DELETE #destroy" do
    login_user
    let(:user) { controller.current_user }
    it "destroys the requested leave_request" do
      leave_request = create :leave_request, user: user
      expect {
        delete :destroy, params: { id: leave_request.to_param }
      }.to change(LeaveRequest, :count).by(-1)
    end

    it "redirects to the forms list" do
      leave_request = create :leave_request, user: user
      delete :destroy, params: { id: leave_request.to_param }
      expect(response).to redirect_to(user_forms_path(user))
    end
  end

  describe "POST #submit" do
    login_user
    context "with unsubmitted request" do
      let(:leave_request) { create :leave_request }

      it "assigns the leave_request as @approvable" do
        post :submit, params: { id: leave_request.to_param }
        expect(assigns[:approvable]).to be_a(LeaveRequest)
        expect(assigns[:approvable]).to eq leave_request
        expect(assigns[:approvable]).to be_persisted
      end

      it "assigns the approval_state as @approval_state" do
        post :submit, params: { id: leave_request.to_param }
        expect(assigns[:approval_state]).to eq leave_request.approval_state
        expect(assigns[:approval_state]).to be_persisted
      end

      it "sends the submit event to the approval_state, followed by the send_to_unopened event" do
        post :submit, params: { id: leave_request.to_param }
        expect(assigns[:approval_state].aasm_state).to eq "unopened"
      end

      it "redirects to the leave_request_path" do
        post :submit, params: { id: leave_request.to_param }
        expect(response).to redirect_to leave_request_path(leave_request)
      end

      it "sends an email" do
        expect { post :submit, params: { id: leave_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "with submitted request" do
      let(:leave_request) { create :leave_request, :submitted }
      let(:approval_state) { leave_request.approval_state }

      it "redirects to the leave_request" do
        post :submit, params: { id: leave_request.to_param }
        expect(response).to redirect_to leave_request_path(leave_request)
      end

      it "shows an error message" do
        post :submit, params: { id: leave_request.to_param }
        expect(flash[:notice]).not_to be_empty
      end

      it "doesnt send an email" do
        expect { post :submit, params: { id: leave_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end

  describe "POST review" do
    login_user
    context "with unopened request" do
      let(:leave_request) { create :leave_request, :unopened }
      let(:approval_state) { leave_request.approval_state }

      it "assigns the leave_request as @approvable" do
        post :review, params: { id: leave_request.to_param }
        expect(assigns[:approvable]).to be_a(LeaveRequest)
        expect(assigns[:approvable]).to eq leave_request
        expect(assigns[:approvable]).to be_persisted
      end

      it "assigns the approval_state as @approval_state" do
        post :review, params: { id: leave_request.to_param }
        expect(assigns[:approval_state]).to eq approval_state
        expect(assigns[:approval_state]).to be_persisted
      end

      it "sends the review event to the approval_state" do
        post :review, params: { id: leave_request.to_param }
        expect(assigns[:approval_state].aasm_state).to eq "in_review"
      end

      it "redirects to the leave_request_path" do
        post :review, params: { id: leave_request.to_param }
        expect(response).to redirect_to leave_request_path(leave_request)
      end
    end

    context "with non-unopened request" do
      let(:leave_request) { create :leave_request }
      let(:approval_state) { leave_request.approval_state }

      it "redirects to the leave_request" do
        post :review, params: { id: leave_request.to_param }
        expect(response).to redirect_to leave_request_path(leave_request)
      end

      it "shows an error message" do
        post :review, params: { id: leave_request.to_param }
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe "POST reject" do
    login_user
    context "with in_review request" do
      let(:leave_request) { create :leave_request, :in_review }
      let(:approval_state) { leave_request.approval_state }

      it "assigns the leave_request as @approvable" do
        post :reject, params: { id: leave_request.to_param }
        expect(assigns[:approvable]).to be_a(LeaveRequest)
        expect(assigns[:approvable]).to eq leave_request
        expect(assigns[:approvable]).to be_persisted
      end

      it "assigns the approval_state as @approval_state" do
        post :reject, params: { id: leave_request.to_param }
        expect(assigns[:approval_state]).to eq approval_state
        expect(assigns[:approval_state]).to be_persisted
      end

      it "sends the reject event to the approval_state" do
        post :reject, params: { id: leave_request.to_param }
        expect(assigns[:approval_state].aasm_state).to eq "rejected"
      end

      it "redirects to the leave_request_path" do
        post :reject, params: { id: leave_request.to_param }
        expect(response).to redirect_to leave_request_path(leave_request)
      end

      it "sends an email" do
        expect { post :reject, params: { id: leave_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "with non-in_review request" do
      let(:leave_request) { create :leave_request }
      let(:approval_state) { leave_request.approval_state }

      it "redirects to the leave_request" do
        post :reject, params: { id: leave_request.to_param }
        expect(response).to redirect_to leave_request_path(leave_request)
      end

      it "shows an error message" do
        post :reject, params: { id: leave_request.to_param }
        expect(flash[:notice]).not_to be_empty
      end

      it "doesnt send an email" do
        expect { post :reject, params: { id: leave_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end

  describe "POST accept" do
    context "with in_review request" do
      login_user
      let(:r) { controller.current_user }
      let(:u) { create :user_with_approvers, reviewer_user: r }
      let(:leave_request) { create :leave_request, :in_review, user: u }
      let(:approval_state) { leave_request.approval_state }

      it "assigns the leave_request as @approvable" do
        post :accept, params: { id: leave_request.to_param }
        expect(assigns[:approvable]).to be_a(LeaveRequest)
        expect(assigns[:approvable]).to eq leave_request
        expect(assigns[:approvable]).to be_persisted
      end

      it "assigns the approval_state as @approval_state" do
        post :accept, params: { id: leave_request.to_param }
        expect(assigns[:approval_state]).to eq approval_state
        expect(assigns[:approval_state]).to be_persisted
      end

      it "sends the accept event to the approval_state" do
        post :accept, params: { id: leave_request.to_param }
        expect(assigns[:approval_state].aasm_state).to eq "accepted"
      end

      it "redirects to the leave_request_path" do
        post :accept, params: { id: leave_request.to_param }
        expect(response).to redirect_to leave_request_path(leave_request)
      end

      it "sends an email" do
        expect { post :accept, params: { id: leave_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "with non-in_review request" do
      login_user
      let(:leave_request) { create :leave_request }
      let(:approval_state) { leave_request.approval_state }

      it "redirects to the leave_request" do
        post :accept, params: { id: leave_request.to_param }
        expect(response).to redirect_to leave_request_path(leave_request)
      end

      it "shows an error message" do
        post :accept, params: { id: leave_request.to_param }
        expect(flash[:notice]).not_to be_empty
      end

      it "doesnt send an email" do
        expect { post :accept, params: { id: leave_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end
end
