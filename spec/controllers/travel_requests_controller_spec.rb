require 'rails_helper'

RSpec.describe TravelRequestsController, type: :controller do
  describe "GET #index" do
    # there is no travelrequest#index
  end

  describe "GET #show" do
    context 'as user' do
      login_user
      let(:user) { controller.current_user }

      it "assigns the requested travel_request as @travel_request" do
        travel_request = create :travel_request
        get :show, params: {id: travel_request.to_param}
        expect(assigns(:travel_request)).to eq travel_request
      end

      it "assigns the user as @user" do
        travel_request = create :travel_request
        get :show, params: {id: travel_request.to_param}
        expect(assigns(:user)).to eq user
      end
    end

    context 'as reviewer' do
      login_user
      let(:r_user) { controller.current_user }
      let(:user) { create :user_with_approvers, reviewer_user: r_user }
      let(:travel_request) { create :travel_request, :unopened, user: user }

      it "assigns the current_user as @user" do
        get :show, params: { id: travel_request.to_param }
        expect(assigns(:user)).to eq r_user
      end

      it "assigns the requested travel_request as @leave_request" do
        get :show, params: { id: travel_request.to_param }
        expect(assigns(:travel_request)).to eq travel_request
      end

      it "assigns the current_user's user_approvals_path as @back_path" do
        get :show, params: { id: travel_request.to_param }
        expect(assigns(:back_path)).to eq user_approvals_path(r_user)
      end

      it "sends the :review event to the leave_request" do
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

end
