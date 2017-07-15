require 'rails_helper'

RSpec.describe TravelRequestsController, type: :controller do
  describe "GET #index" do
    # there is no travelrequest#index
  end

  describe "GET #show" do
    it "assigns the requested travel_request as @travel_request" do
      travel_request = TravelRequest.create! valid_attributes
      get :show, params: {id: travel_request.to_param}, session: valid_session
      expect(assigns(:travel_request)).to eq(travel_request)
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

  describe "GET #edit" do
    it "assigns the requested travel_request as @travel_request" do
      travel_request = TravelRequest.create! valid_attributes
      get :edit, params: {id: travel_request.to_param}, session: valid_session
      expect(assigns(:travel_request)).to eq(travel_request)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new TravelRequest" do
        expect {
          post :create, params: {travel_request: valid_attributes}, session: valid_session
        }.to change(TravelRequest, :count).by(1)
      end

      it "assigns a newly created travel_request as @travel_request" do
        post :create, params: {travel_request: valid_attributes}, session: valid_session
        expect(assigns(:travel_request)).to be_a(TravelRequest)
        expect(assigns(:travel_request)).to be_persisted
      end

      it "redirects to the created travel_request" do
        post :create, params: {travel_request: valid_attributes}, session: valid_session
        expect(response).to redirect_to(TravelRequest.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved travel_request as @travel_request" do
        post :create, params: {travel_request: invalid_attributes}, session: valid_session
        expect(assigns(:travel_request)).to be_a_new(TravelRequest)
      end

      it "re-renders the 'new' template" do
        post :create, params: {travel_request: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested travel_request" do
        travel_request = TravelRequest.create! valid_attributes
        put :update, params: {id: travel_request.to_param, travel_request: new_attributes}, session: valid_session
        travel_request.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested travel_request as @travel_request" do
        travel_request = TravelRequest.create! valid_attributes
        put :update, params: {id: travel_request.to_param, travel_request: valid_attributes}, session: valid_session
        expect(assigns(:travel_request)).to eq(travel_request)
      end

      it "redirects to the travel_request" do
        travel_request = TravelRequest.create! valid_attributes
        put :update, params: {id: travel_request.to_param, travel_request: valid_attributes}, session: valid_session
        expect(response).to redirect_to(travel_request)
      end
    end

    context "with invalid params" do
      it "assigns the travel_request as @travel_request" do
        travel_request = TravelRequest.create! valid_attributes
        put :update, params: {id: travel_request.to_param, travel_request: invalid_attributes}, session: valid_session
        expect(assigns(:travel_request)).to eq(travel_request)
      end

      it "re-renders the 'edit' template" do
        travel_request = TravelRequest.create! valid_attributes
        put :update, params: {id: travel_request.to_param, travel_request: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested travel_request" do
      travel_request = TravelRequest.create! valid_attributes
      expect {
        delete :destroy, params: {id: travel_request.to_param}, session: valid_session
      }.to change(TravelRequest, :count).by(-1)
    end

    it "redirects to the travel_requests list" do
      travel_request = TravelRequest.create! valid_attributes
      delete :destroy, params: {id: travel_request.to_param}, session: valid_session
      expect(response).to redirect_to(travel_requests_url)
    end
  end

end
