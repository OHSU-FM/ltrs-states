require 'rails_helper'

RSpec.describe LeaveRequestsController, type: :controller do
  describe "GET #index" do
    it "assigns all leave_requests as @leave_requests" do
      leave_request = create :leave_request
      get :index
      expect(assigns(:leave_requests)).to eq([leave_request])
    end
  end

  describe "GET #show" do
    it "assigns the requested leave_request as @leave_request" do
      leave_request = create :leave_request
      get :show, params: {id: leave_request.to_param}
      expect(assigns(:leave_request)).to eq(leave_request)
    end
  end

  describe "GET #new" do
    it "assigns a new leave_request as @leave_request" do
      get :new
      expect(assigns(:leave_request)).to be_a_new(LeaveRequest)
    end
  end

  describe "GET #edit" do
    it "assigns the requested leave_request as @leave_request" do
      leave_request = create :leave_request
      get :edit, params: {id: leave_request.to_param}
      expect(assigns(:leave_request)).to eq(leave_request)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_attributes) { build(:leave_request).attributes }

      it "creates a new LeaveRequest" do
        expect {
          post :create, params: {leave_request: valid_attributes}
        }.to change(LeaveRequest, :count).by(1)
      end

      it "assigns a newly created leave_request as @leave_request" do
        post :create, params: {leave_request: valid_attributes}
        expect(assigns(:leave_request)).to be_a(LeaveRequest)
        expect(assigns(:leave_request)).to be_persisted
      end

      it "redirects to the created leave_request" do
        post :create, params: {leave_request: valid_attributes}
        expect(response).to redirect_to(LeaveRequest.last)
      end
    end

    context "with invalid params" do
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

  describe "PUT #update" do
    context "with valid params" do
      let(:valid_attributes) { build(:leave_request).attributes }
      let(:new_attributes) { build(:leave_request).attributes }

      it "updates the requested leave_request" do
        leave_request = create :leave_request
        put :update, params: {id: leave_request.to_param, leave_request: new_attributes}
        leave_request.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested leave_request as @leave_request" do
        leave_request = create :leave_request
        put :update, params: {id: leave_request.to_param, leave_request: valid_attributes}
        expect(assigns(:leave_request)).to eq(leave_request)
      end

      it "redirects to the leave_request" do
        leave_request = create :leave_request
        put :update, params: {id: leave_request.to_param, leave_request: valid_attributes}
        expect(response).to redirect_to(leave_request)
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) {
        build(:leave_request).attributes.except("user_id").merge("user_id" => nil)
      }

      it "assigns the leave_request as @leave_request" do
        leave_request = create :leave_request
        put :update, params: {id: leave_request.to_param, leave_request: invalid_attributes}
        expect(assigns(:leave_request)).to eq(leave_request)
      end

      it "re-renders the 'edit' template" do
        leave_request = create :leave_request
        put :update, params: {id: leave_request.to_param, leave_request: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested leave_request" do
      leave_request = create :leave_request
      expect {
        delete :destroy, params: {id: leave_request.to_param}
      }.to change(LeaveRequest, :count).by(-1)
    end

    it "redirects to the leave_requests list" do
      leave_request = create :leave_request
      delete :destroy, params: {id: leave_request.to_param}
      expect(response).to redirect_to(leave_requests_url)
    end
  end

end
