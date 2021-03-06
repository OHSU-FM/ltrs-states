require 'rails_helper'

RSpec.describe ReimbursementRequestsController, type: :controller do
  describe "GET #index" do
    # there is no reimbursementrequest#index
  end

  describe "GET #show" do
    login_user

    context 'as user' do
      let(:user) { controller.current_user }
      let(:reimbursement_request) { create :reimbursement_request}

      it "assigns the requested reimbursement_request as @reimbursement_request" do
        get :show, params: {id: reimbursement_request.to_param}
        expect(assigns(:reimbursement_request)).to eq reimbursement_request
      end

      it "assigns the user as @user" do
        get :show, params: {id: reimbursement_request.to_param}
        expect(assigns(:user)).to eq user
      end
    end

    context 'as reviewer' do
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
    login_user

    context "with valid params" do
      let(:user) { controller.current_user }
      let(:gftr) { create :gf_travel_request, :accepted }
      let(:valid_attributes) { build(:reimbursement_request, user: user, gf_travel_request: gftr).attributes }

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

  describe 'PUT #update' do
    context 'with unsubmitted request' do
      let(:rr) { create :reimbursement_request, user: user }

      context 'with valid_attributes' do
        let(:valid_attributes) { rr.attributes.update(air_use: true) }

        context 'with logged in user' do
          login_user
          let(:user) { controller.current_user }

          it 'updates the request' do
            patch :update, params: { id: rr.id, reimbursement_request: valid_attributes }
            rr.reload
            expect(rr.air_use).to be_truthy
          end
        end

        context 'with logged in delegate' do
          login_delegate
          let(:user) { controller.current_user.delegators.first }

          it 'updates the request' do
            patch :update, params: { id: rr.id, reimbursement_request: valid_attributes }
            rr.reload
            expect(rr.air_use).to be_truthy
          end
        end

        context 'without logged in user' do
          let(:user) { create :user }

          it 'doesnt update the request' do
            patch :update, params: { id: rr.id, reimbursement_request: valid_attributes }
            rr.reload
            expect(rr.air_use).to be_falsey
          end
        end

        # TODO this is supposed to test Reimbursementrequest#update_mrrs, but
        # i don't think the params work because when start/end dates are changed
        # in the form, it's the mrr attributes that actually trigger the
        # difference in the number of associated mrrs. the below params don't
        # include mrr attrs at all. we need a method like rr.attributes that
        # includes all the associated attributes as well
        #
        # context 'when dates change' do
        #   login_user
        #   let(:user) { controller.current_user }
        #
        #   it 'deletes duplicate mrrs' do
        #     attrs = valid_attributes.update(depart_date: rr.depart_date - 1)
        #     patch :update, params: { id: rr.id, reimbursement_request: attrs }
        #     rr.reload
        #     dates = rr.meal_reimbursement_requests.map(&:reimb_date)
        #     expect(dates.detect{|e| dates.count(e) > 1 })
        #       .to eq nil
        #   end
        # end
      end

      context 'with invalid_attributes' do
        login_user
        let(:user) { controller.current_user }
        let(:invalid_attributes) { rr.attributes.update("return_date" => nil) }

        it 'renders edit' do
          patch :update, params: { id: rr.id, reimbursement_request: invalid_attributes }
          expect(response).to render_template(:edit)
          expect(assigns[:reimbursement_request]).to eq rr
        end
      end
    end

    context 'with submitted request' do
      login_user
      let(:rr) { create :reimbursement_request, :submitted, user: controller.current_user }
      let(:new_date) { Date.today + 7 }
      let(:params) { rr.attributes.update(return_date: new_date) }

      # rr shouldn't be editable after it's been submitted
      it 'redirect_to to the record' do
        original_date = rr.return_date
        patch :update, params: { id: rr.id, reimbursement_request: params }
        expect(response).to redirect_to root_path
        rr.reload
        expect(rr.return_date).to eq original_date
      end
    end
  end

  describe "DELETE #destroy" do
    login_user
    let(:user) { controller.current_user }
    let!(:reimbursement_request) { create :reimbursement_request, user: user}

    it "doesn't destroy the requested reimbursement_request" do
      expect {
        delete :destroy, params: { id: reimbursement_request.to_param }
      }.to change(ReimbursementRequest, :count).by(0)
    end

    it "redirects to the root_path" do
      delete :destroy, params: { id: reimbursement_request.to_param }
      expect(response).to redirect_to root_path
      expect(response.status).to eq 302
    end
  end

  describe 'POST #submit' do
    login_user
    let(:user) { controller.current_user }
    let(:reimbursement_request) { create :reimbursement_request, user: user }
    let(:submittable_rr) { create :submittable_reimbursement_request, user: user }

    it 'should fail if user has not attached an itinerary and agenda' do
      post :submit, params: { id: reimbursement_request.to_param }
      expect(reimbursement_request.approval_state).to be_unsubmitted
    end

    it 'should fail if the user has not answered a question' do
      submittable_rr.update!(air_use: nil)
      post :submit, params: { id: submittable_rr.to_param }
      expect(reimbursement_request.approval_state).to be_unsubmitted
    end

    it 'should succeed if user has attached an itinerary and agenda' do
      post :submit, params: { id: submittable_rr.to_param }
      expect(submittable_rr.approval_state).to be_unopened
    end
  end

  describe "POST #accept" do
    login_user
    let(:user) { create :user_with_approvers, reviewer_user: controller.current_user}
    let(:approval_state) { reimbursement_request.approval_state }

    context "with in_review request" do
      let(:reimbursement_request) { create :reimbursement_request, :in_review, user: user }

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
      let(:reimbursement_request) { create :reimbursement_request, user: user }

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
