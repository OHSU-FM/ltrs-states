require 'rails_helper'

RSpec.describe GrantFundedTravelRequestsController, type: :controller do
  describe "GET #index" do
    # there is no grantfundedtravelrequest#index
  end

  describe "GET #show" do
    login_user

    context 'as user' do
      let(:user) { controller.current_user }
      let(:gf_travel_request) { create :gf_travel_request }

      it "assigns the requested gf_travel_request as @gf_travel_request" do
        get :show, params: {id: gf_travel_request.to_param}
        expect(assigns(:gf_travel_request)).to eq gf_travel_request
      end

      it "assigns the user as @user" do
        get :show, params: {id: gf_travel_request.to_param}
        expect(assigns(:user)).to eq user
      end
    end

    context 'as reviewer' do
      let(:r_user) { controller.current_user }
      let(:user) { create :user_with_approvers, reviewer_user: r_user }
      let(:gf_travel_request) { create :gf_travel_request, :unopened, user: user }

      it "assigns the current_user as @user" do
        get :show, params: { id: gf_travel_request.to_param }
        expect(assigns(:user)).to eq r_user
      end

      it "assigns the requested gf_travel_request as @gf_travel_request" do
        get :show, params: { id: gf_travel_request.to_param }
        expect(assigns(:gf_travel_request)).to eq gf_travel_request
      end

      it "assigns the current_user's user_approvals_path as @back_path" do
        get :show, params: { id: gf_travel_request.to_param }
        expect(assigns(:back_path)).to eq user_approvals_path(r_user)
      end

      it "sends the :review event to the gf_travel_request" do
        get :show, params: { id: gf_travel_request.to_param }
        expect(gf_travel_request.approval_state).to be_in_review
      end
    end
  end

  describe "GET #new" do
    login_user

    it "assigns a new gf_travel_request as @gf_travel_request" do
      get :new
      expect(assigns(:gf_travel_request)).to be_a_new(GrantFundedTravelRequest)
      expect(assigns(:gf_travel_request).form_user).to eq controller.current_user.full_name
      expect(assigns(:gf_travel_request).form_email).to eq controller.current_user.email
    end
  end

  describe "POST #create" do
    context "with valid params" do
      login_user
      let(:user) { controller.current_user }
      let(:valid_attributes) { build(:gf_travel_request, user: user).attributes }

      it "creates a new GrantFundedTravelRequest" do
        expect {
          post :create, params: { grant_funded_travel_request: valid_attributes }
        }.to change(GrantFundedTravelRequest, :count).by(1)
      end

      it "assigns a newly created gf_travel_request as @gf_travel_request" do
        post :create, params: { grant_funded_travel_request: valid_attributes }
        expect(assigns(:gf_travel_request)).to be_a(GrantFundedTravelRequest)
        expect(assigns(:gf_travel_request)).to be_persisted
      end

      it "redirects to the created gf_travel_request" do
        post :create, params: { grant_funded_travel_request: valid_attributes }
        expect(response).to redirect_to(GrantFundedTravelRequest.last)
      end

      it 'updates the users traveler profile if new information is included' do
        valid_attributes.update(tsa_pre: '123')
        post :create, params: { grant_funded_travel_request: valid_attributes }
        user.reload
        expect(user.tsa_pre).to eq '123'
      end
    end

    context 'with valid params and a delegate user' do
      login_user
      let(:d_user) { controller.current_user }
      let(:user) { create :user }
      let(:delegation) { create :user_delegation, user: user, delegate_user: d_user }
      let(:valid_attributes) { build(:gf_travel_request, user: user).attributes }

      it "creates a new GrantFundedTravelRequest" do
        expect {
          post :create, params: { grant_funded_travel_request: valid_attributes }
        }.to change(GrantFundedTravelRequest, :count).by(1)
      end

      it "form_user should be delegate user's full_name" do
        post :create, params: { grant_funded_travel_request: valid_attributes }
        expect(GrantFundedTravelRequest.last.form_user).to eq controller.current_user.full_name
      end

      it "form_email should be delegate user's email" do
        post :create, params: { grant_funded_travel_request: valid_attributes }
        expect(GrantFundedTravelRequest.last.form_email).to eq controller.current_user.email
      end

      it "#user should not be current_user" do
        post :create, params: { grant_funded_travel_request: valid_attributes }
        expect(GrantFundedTravelRequest.last.user).not_to eq controller.current_user
        expect(GrantFundedTravelRequest.last.user).to eq user
      end
    end

    context "with invalid params" do
      login_user
      let(:invalid_attributes) {
        build(:gf_travel_request).attributes.except("depart_date").merge("depart_date" => nil)
      }

      it "assigns a newly created but unsaved gf_travel_request as @gf_travel_request" do
        post :create, params: { grant_funded_travel_request: invalid_attributes }
        expect(assigns(:gf_travel_request)).to be_a_new(GrantFundedTravelRequest)
      end

      it "re-renders the 'new' template" do
        post :create, params: { grant_funded_travel_request: invalid_attributes }
        expect(response).to render_template("new")
      end
    end
  end

  describe 'PUT #update' do
    context 'with unsubmitted request' do
      let(:gftr) { create :gf_travel_request, user: user }

      context 'with valid_attributes' do
        let(:date) { Date.today + 7 }
        let(:valid_attributes) { gftr.attributes.update("return_date" => date) }

        context 'with logged in user' do
          login_user
          let(:user) { controller.current_user }

          it 'updates the request' do
            patch :update, params: { id: gftr.id, grant_funded_travel_request: valid_attributes }
            gftr.reload
            expect(gftr.return_date).to eq date
          end
        end

        context 'with logged in delegate' do
          login_delegate
          let(:user) { controller.current_user.delegators.first }

          it 'updates the request' do
            patch :update, params: { id: gftr.id, grant_funded_travel_request: valid_attributes }
            gftr.reload
            expect(gftr.return_date).to eq date
          end
        end

        context 'without logged in user' do
          let(:user) { create :user }
          let(:gftr2) { create :gf_travel_request }

          it 'doesnt update the request' do
            patch :update, params: { id: gftr2.id, grant_funded_travel_request: valid_attributes }
            gftr2.reload
            expect(gftr2.return_date).not_to eq date
          end
        end
      end

      context 'with invalid_attributes' do
        login_user
        let(:user) { controller.current_user }
        let(:invalid_attributes) { gftr.attributes.update(return_date: nil) }

        it 'renders edit' do
          patch :update, params: { id: gftr.id, grant_funded_travel_request: invalid_attributes }
          expect(response).to redirect_to gftr
          expect(assigns[:gf_travel_request]).to eq gftr
        end
      end
    end

    context 'with submitted request' do
      login_user
      let(:gftr) { create :gf_travel_request, :submitted, user: controller.current_user }
      let(:new_date) { Date.today + 7 }
      let(:params) { gftr.attributes.update(return_date: new_date) }

      # gftr shouldn't be editable after it's been submitted
      it 'redirect_to to the record' do
        original_date = gftr.return_date
        patch :update, params: { id: gftr.id, grant_funded_travel_request: params }
        expect(response).to redirect_to root_path
        gftr.reload
        expect(gftr.return_date).to eq original_date
      end
    end
  end

  describe "DELETE #destroy" do
    login_user
    let(:user) { controller.current_user }
    let!(:gf_travel_request) { create :gf_travel_request, user: user}

    it "destroys the requested gf_travel_request" do
      expect {
        delete :destroy, params: { id: gf_travel_request.to_param }
      }.to change(GrantFundedTravelRequest, :count).by(-1)
    end

    it "redirects to the forms list" do
      delete :destroy, params: { id: gf_travel_request.to_param }
      expect(response).to redirect_to(user_forms_path(user))
    end
  end

  describe "POST accept" do
    login_user
    let(:user) { create :user_with_approvers, reviewer_user: controller.current_user }
    let(:approval_state) { gf_travel_request.approval_state }

    context "with in_review request" do
      let(:gf_travel_request) { create :gf_travel_request, :in_review, user: user }

      it "assigns the gf_travel_request as @approvable" do
        post :accept, params: { id: gf_travel_request.to_param }
        expect(assigns[:approvable]).to be_a(GrantFundedTravelRequest)
        expect(assigns[:approvable]).to eq gf_travel_request
        expect(assigns[:approvable]).to be_persisted
      end

      it "assigns the approval_state as @approval_state" do
        post :accept, params: { id: gf_travel_request.to_param }
        expect(assigns[:approval_state]).to eq approval_state
        expect(assigns[:approval_state]).to be_persisted
      end

      it "sends the accept event to the approval_state" do
        post :accept, params: { id: gf_travel_request.to_param }
        expect(assigns[:approval_state].aasm_state).to eq "accepted"
      end

      it "redirects to the grant_funded_travel_request_path" do
        post :accept, params: { id: gf_travel_request.to_param }
        expect(response).to redirect_to grant_funded_travel_request_path(gf_travel_request)
      end

      # user has single reviewer, so we can test ReimbursementRequest creation here
      it "creates a new reimbusement request on success" do
        expect {
          post :accept, params: { id: gf_travel_request.to_param }
        }.to change(ReimbursementRequest, :count).by(1)
      end

      it "sends two emails (accepted and reimb_req_available)" do
        expect {
          post :accept, params: { id: gf_travel_request.to_param }
        }.to change{ ActionMailer::Base.deliveries.count }.by(2)
      end
    end

    context "when user has multiple approvers" do
      login_user
      let(:approval_state) { gf_travel_request.approval_state }

      context "the first time around" do
        let(:user) { create :user_two_reviewers, reviewer1: controller.current_user }
        let(:gf_travel_request) { create :gf_travel_request, :in_review, user: user }

        it "doesn't create a new reimbusement request on success" do
          expect {
            post :accept, params: { id: gf_travel_request.to_param }
          }.to change(ReimbursementRequest, :count).by(0)
        end

        it "sends one emails (first_reivewer_accepted)" do
          expect {
            post :accept, params: { id: gf_travel_request.to_param }
          }.to change{ ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context "the last time around" do
        let(:user) { create :user_two_reviewers, reviewer2: controller.current_user }
        let(:gf_travel_request) { create :gf_travel_request, :in_review, user: user }

        before(:each) do
          gf_travel_request.approval_state.update!(approval_order: 2)
        end

        it "creates a new reimbusement request on success" do
          expect {
            post :accept, params: { id: gf_travel_request.to_param }
          }.to change(ReimbursementRequest, :count).by(1)
        end

        it "sends two emails (accepted and reimb_req_available)" do
          expect {
            post :accept, params: { id: gf_travel_request.to_param }
          }.to change{ ActionMailer::Base.deliveries.count }.by(2)
        end
      end
    end

    context "with non-in_review request" do
      let(:gf_travel_request) { create :gf_travel_request, user: user }

      it "redirects to the gf_travel_request" do
        post :accept, params: { id: gf_travel_request.to_param }
        expect(response).to redirect_to grant_funded_travel_request_path(gf_travel_request)
      end

      it "shows an error message" do
        post :accept, params: { id: gf_travel_request.to_param }
        expect(flash[:notice]).not_to be_empty
      end

      it "doesnt send an email" do
        expect { post :accept, params: { id: gf_travel_request.to_param } }
          .to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end
end
