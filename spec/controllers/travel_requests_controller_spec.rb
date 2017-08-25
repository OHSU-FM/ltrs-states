require 'rails_helper'

RSpec.describe TravelRequestsController, type: :controller do
  describe "GET #index" do
    # there is no travelrequest#index
  end

  describe "GET #show" do
    login_user

    context 'as user' do
      let(:user) { controller.current_user }
      let(:travel_request) { create :travel_request }

      it "assigns the requested travel_request as @travel_request" do
        get :show, params: { id: travel_request.to_param }
        expect(assigns(:travel_request)).to eq travel_request
      end

      it "assigns the user as @user" do
        get :show, params: { id: travel_request.to_param }
        expect(assigns(:user)).to eq user
      end
    end

    context 'as reviewer' do
      let(:r_user) { controller.current_user }
      let(:user) { create :user_with_approvers, reviewer_user: r_user }
      let(:travel_request) { create :travel_request, :unopened, user: user }

      it "assigns the current_user as @user" do
        get :show, params: { id: travel_request.to_param }
        expect(assigns(:user)).to eq r_user
      end

      it "assigns the requested travel_request as @travel_request" do
        get :show, params: { id: travel_request.to_param }
        expect(assigns(:travel_request)).to eq travel_request
      end

      it "assigns the current_user's user_approvals_path as @back_path" do
        get :show, params: { id: travel_request.to_param }
        expect(assigns(:back_path)).to eq user_approvals_path(r_user)
      end

      it "sends the :review event to the travel_request" do
        get :show, params: { id: travel_request.to_param }
        expect(travel_request.approval_state).to be_in_review
      end
    end
  end

  describe "GET #new" do
    login_user

    it "assigns a new travel_request as @travel_request" do
      get :new
      expect(assigns(:back_path)).to eq user_forms_path(controller.current_user)
      expect(assigns(:travel_request)).to be_a_new(TravelRequest)
      expect(assigns(:travel_request).form_user).to eq controller.current_user.full_name
      expect(assigns(:travel_request).form_email).to eq controller.current_user.email
    end
  end

  describe "POST #create" do
    context "with valid params" do
      login_user
      let(:user) { controller.current_user }
      let(:valid_attributes) { build(:travel_request, user: user) .attributes }

      it "creates a new TravelRequest" do
        expect {
          post :create, params: { travel_request: valid_attributes }
        }.to change(TravelRequest, :count).by(1)
      end

      it "assigns a newly created travel_request as @travel_request" do
        post :create, params: { travel_request: valid_attributes }
        expect(assigns(:travel_request)).to be_a(TravelRequest)
        expect(assigns(:travel_request)).to be_persisted
      end

      it "redirects to the created travel_request" do
        post :create, params: { travel_request: valid_attributes }
        expect(response).to redirect_to(TravelRequest.last)
      end
    end

  # TODO these dont apply as long as delegation isnt working for travel requests
    # context 'with valid params and a delegate user' do
    #   login_user
    #   let(:d_user) { controller.current_user }
    #   let(:user) { create :user }
    #   let(:delegation) { create :user_delegation, user: user, delegate_user: d_user }
    #   let(:valid_attributes) { build(:travel_request, user: user).attributes }
    #
    #   it "creates a new TravelRequest" do
    #     expect {
    #       post :create, params: { travel_request: valid_attributes }
    #     }.to change(TravelRequest, :count).by(1)
    #   end
    #
    #   it "form_user should be delegate user's full_name" do
    #     post :create, params: { travel_request: valid_attributes }
    #     expect(TravelRequest.last.form_user).to eq controller.current_user.full_name
    #   end
    #
    #   it "form_email should be delegate user's email" do
    #     post :create, params: { travel_request: valid_attributes }
    #     expect(TravelRequest.last.form_email).to eq controller.current_user.email
    #   end
    #
    #   it "#user should not be current_user" do
    #     post :create, params: { travel_request: valid_attributes }
    #     expect(TravelRequest.last.user).not_to eq controller.current_user
    #     expect(TravelRequest.last.user).to eq user
    #   end
    # end

    context "with invalid params" do
      login_user
      let(:invalid_attributes) {
        build(:travel_request).attributes.except("dest_depart_date").merge("dest_depart_date" => nil)
      }

      it "assigns a newly created but unsaved travel_request as @travel_request" do
        post :create, params: { travel_request: invalid_attributes }
        expect(assigns(:travel_request)).to be_a_new(TravelRequest)
      end

      it "re-renders the 'new' template" do
        post :create, params: { travel_request: invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe "DELETE #destroy" do
    login_user
    let(:user) { controller.current_user }
    let!(:travel_request) { create :travel_request, user: user}

    it "destroys the requested travel_request" do
      expect {
        delete :destroy, params: { id: travel_request.to_param }
      }.to change(TravelRequest, :count).by(-1)
    end

    it "redirects to the travel_requests list" do
      delete :destroy, params: { id: travel_request.to_param }
      expect(response).to redirect_to(user_forms_path(user))
    end
  end

  describe "POST #submit" do
    login_user

    context "with unsubmitted request" do
      let(:travel_request) { create :travel_request }

      it "assigns the travel_request as @approvable" do
        post :submit, params: { id: travel_request.to_param }
        expect(assigns[:approvable]).to be_a(TravelRequest)
        expect(assigns[:approvable]).to eq travel_request
        expect(assigns[:approvable]).to be_persisted
      end

      it "assigns the approval_state as @approval_state" do
        post :submit, params: { id: travel_request.to_param }
        expect(assigns[:approval_state]).to eq travel_request.approval_state
        expect(assigns[:approval_state]).to be_persisted
      end

      it "sends the submit event to the approval_state, followed by the send_to_unopened event" do
        post :submit, params: { id: travel_request.to_param }
        expect(assigns[:approval_state].aasm_state).to eq "unopened"
      end

      it "redirects to the travel_request_path" do
        post :submit, params: { id: travel_request.to_param }
        expect(response).to redirect_to travel_request_path(travel_request)
      end

      it "sends an email" do
        expect { post :submit, params: { id: travel_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "with submitted request" do
      let(:travel_request) { create :travel_request, :submitted }
      let(:approval_state) { travel_request.approval_state }

      it "redirects to the travel_request" do
        post :submit, params: { id: travel_request.to_param }
        expect(response).to redirect_to travel_request_path(travel_request)
      end

      it "shows an error message" do
        post :submit, params: { id: travel_request.to_param }
        expect(flash[:notice]).not_to be_empty
      end

      it "doesnt send an email" do
        expect { post :submit, params: { id: travel_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end

  describe "POST review" do
    login_reviewer
    let(:user) { controller.current_user.reviewable_users.last }
    let(:approval_state) { travel_request.approval_state }

    context "with unopened request" do
      let(:travel_request) { create :travel_request, :unopened, user: user }

      it "assigns the travel_request as @approvable" do
        post :review, params: { id: travel_request.to_param }
        expect(assigns[:approvable]).to be_a(TravelRequest)
        expect(assigns[:approvable]).to eq travel_request
        expect(assigns[:approvable]).to be_persisted
      end

      it "assigns the approval_state as @approval_state" do
        post :review, params: { id: travel_request.to_param }
        expect(assigns[:approval_state]).to eq approval_state
        expect(assigns[:approval_state]).to be_persisted
      end

      it "sends the review event to the approval_state" do
        post :review, params: { id: travel_request.to_param }
        expect(assigns[:approval_state].aasm_state).to eq "in_review"
      end

      it "redirects to the travel_request_path" do
        post :review, params: { id: travel_request.to_param }
        expect(response).to redirect_to travel_request_path(travel_request)
      end
    end

    context "with non-unopened request" do
      let(:travel_request) { create :travel_request, user: user }

      it "redirects to the travel_request" do
        post :review, params: { id: travel_request.to_param }
        expect(response).to redirect_to travel_request_path(travel_request)
      end

      it "shows an error message" do
        post :review, params: { id: travel_request.to_param }
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe "POST reject" do
    login_reviewer
    let(:user) { controller.current_user.reviewable_users.last }
    let(:approval_state) { travel_request.approval_state }

    context "with in_review request" do
      let(:travel_request) { create :travel_request, :in_review, user: user }

      it "assigns the travel_request as @approvable" do
        post :reject, params: { id: travel_request.to_param }
        expect(assigns[:approvable]).to be_a(TravelRequest)
        expect(assigns[:approvable]).to eq travel_request
        expect(assigns[:approvable]).to be_persisted
      end

      it "assigns the approval_state as @approval_state" do
        post :reject, params: { id: travel_request.to_param }
        expect(assigns[:approval_state]).to eq approval_state
        expect(assigns[:approval_state]).to be_persisted
      end

      it "sends the reject event to the approval_state" do
        post :reject, params: { id: travel_request.to_param }
        expect(assigns[:approval_state].aasm_state).to eq "rejected"
      end

      it "redirects to the travel_request_path" do
        post :reject, params: { id: travel_request.to_param }
        expect(response).to redirect_to travel_request_path(travel_request)
      end

      it "sends an email" do
        expect { post :reject, params: { id: travel_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "with non-in_review request" do
      let(:travel_request) { create :travel_request, user: user }

      it "redirects to the travel_request" do
        post :reject, params: { id: travel_request.to_param }
        expect(response).to redirect_to travel_request_path(travel_request)
      end

      it "shows an error message" do
        post :reject, params: { id: travel_request.to_param }
        expect(flash[:notice]).not_to be_empty
      end

      it "doesnt send an email" do
        expect { post :reject, params: { id: travel_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end

  describe "POST accept" do
    login_reviewer
    let(:user) { controller.current_user.reviewable_users.last }
    let(:approval_state) { travel_request.approval_state }

    context "with in_review request" do
      let(:travel_request) { create :travel_request, :in_review, user: user }

      it "assigns the travel_request as @approvable" do
        post :accept, params: { id: travel_request.to_param }
        expect(assigns[:approvable]).to be_a(TravelRequest)
        expect(assigns[:approvable]).to eq travel_request
        expect(assigns[:approvable]).to be_persisted
      end

      it "assigns the approval_state as @approval_state" do
        post :accept, params: { id: travel_request.to_param }
        expect(assigns[:approval_state]).to eq approval_state
        expect(assigns[:approval_state]).to be_persisted
      end

      it "sends the accept event to the approval_state" do
        post :accept, params: { id: travel_request.to_param }
        expect(assigns[:approval_state].aasm_state).to eq "accepted"
      end

      it "redirects to the travel_request_path" do
        post :accept, params: { id: travel_request.to_param }
        expect(response).to redirect_to travel_request_path(travel_request)
      end

      it "sends an email" do
        expect { post :accept, params: { id: travel_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "with non-in_review request" do
      let(:travel_request) { create :travel_request, user: user }

      it "redirects to the travel_request" do
        post :accept, params: { id: travel_request.to_param }
        expect(response).to redirect_to travel_request_path(travel_request)
      end

      it "shows an error message" do
        post :accept, params: { id: travel_request.to_param }
        expect(flash[:notice]).not_to be_empty
      end

      it "doesnt send an email" do
        expect { post :accept, params: { id: travel_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end
end
