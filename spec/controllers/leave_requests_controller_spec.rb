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

      it "updates the requested leave_request" do
        leave_request = create :leave_request
        new_attributes = valid_attributes.update("start_date" => Time.new().at_midnight + 10.days)
        put :update, params: {id: leave_request.id, leave_request: new_attributes}
        leave_request.reload
        expect(leave_request.start_date).to eq Time.new().at_midnight + 10.days
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

      describe "state transition during update" do
        it "resets submitted approval_state to unsubmitted" do
          leave_request = create :leave_request, :submitted
          new_attributes = valid_attributes.update("start_date" => Time.new().at_midnight + 10.days)
          put :update, params: {id: leave_request.id, leave_request: new_attributes}
          leave_request.reload
          expect(leave_request.approval_state).to be_unsubmitted
        end

        it "unsubmitted approval_state remains unsubmitted without error" do
          leave_request = create :leave_request
          new_attributes = leave_request.attributes
          put :update, params: {id: leave_request.id, leave_request: new_attributes}
          leave_request.reload
          expect(leave_request.approval_state).to be_unsubmitted
        end

        it "submitted approval_state remains submitted if request not updated" do
          leave_request = create :leave_request, :submitted
          new_attributes = leave_request.attributes # so @leave_request.changed? == false
          put :update, params: {id: leave_request.id, leave_request: new_attributes}
          leave_request.reload
          expect(leave_request.approval_state).to be_submitted
        end

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

  describe "POST #submit" do
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

  describe "POST send_to_unopened" do
    context "with submitted request" do
      let(:leave_request) { create :leave_request, :submitted  }
      let(:approval_state) { leave_request.approval_state }

      it "assigns the leave_request as @approvable" do
        post :send_to_unopened, params: { id: leave_request.to_param }
        expect(assigns[:approvable]).to be_a(LeaveRequest)
        expect(assigns[:approvable]).to eq leave_request
        expect(assigns[:approvable]).to be_persisted
      end

      it "assigns the approval_state as @approval_state" do
        post :send_to_unopened, params: { id: leave_request.to_param }
        expect(assigns[:approval_state]).to eq approval_state
        expect(assigns[:approval_state]).to be_persisted
      end

      it "sends the send_to_unopened event to the approval_state" do
        post :send_to_unopened, params: { id: leave_request.to_param }
        expect(assigns[:approval_state].aasm_state).to eq "unopened"
      end

      it "redirects to the leave_request_path" do
        post :send_to_unopened, params: { id: leave_request.to_param }
        expect(response).to redirect_to leave_request_path(leave_request)
      end
    end

    context "with unsubmitted request" do
      let(:leave_request) { create :leave_request }
      let(:approval_state) { leave_request.approval_state }

      it "redirects to the leave_request" do
        post :send_to_unopened, params: { id: leave_request.to_param }
        expect(response).to redirect_to leave_request_path(leave_request)
      end

      it "shows an error message" do
        post :send_to_unopened, params: { id: leave_request.to_param }
        expect(flash[:notice]).not_to be_empty
      end
    end
  end

  describe "POST review" do
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
        expect(flash[:notice]).not_to be_empty
      end
    end
  end

  describe "POST reject" do
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
      let(:leave_request) { create :leave_request, :in_review }
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
