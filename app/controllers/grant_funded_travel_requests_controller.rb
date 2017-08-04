class GrantFundedTravelRequestsController < ApplicationController
  before_action :load_resources, only: [:show, :edit, :update, :destroy]
  include StateEvents
  authorize_resource
  skip_authorize_resource only: :update_state

  # GET /grant_funded_travel_requests/1
  # GET /grant_funded_travel_requests/1.json
  def show
    authorize! :show, @gf_travel_request
    if hf_transition_to_in_review?(@gf_travel_request, @user) # defined in StateEvents
      @gf_travel_request.approval_state.review!
    end
  end

  # GET /grant_funded_travel_requests/new
  def new
    @gf_travel_request = GrantFundedTravelRequest.new
    @gf_travel_request.form_user = current_user.full_name
    @gf_travel_request.form_email = current_user.email
    @gf_travel_request.user = current_user unless current_user.has_delegators?
  end

  # GET /grant_funded_travel_requests/1/edit
  def edit
  end

  # POST /grant_funded_travel_requests
  # POST /grant_funded_travel_requests.json
  def create
    @gf_travel_request = GrantFundedTravelRequest.new(grant_funded_travel_request_params)
    @gf_travel_request.form_user = current_user.full_name
    @gf_travel_request.form_email = current_user.email

    respond_to do |format|
      if @gf_travel_request.save
        format.html { redirect_to @gf_travel_request, notice: 'Grant funded travel request was successfully created.' }
        format.json { render :show, status: :created, location: @gf_travel_request }
      else
        format.html { render :new }
        format.json { render json: @gf_travel_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grant_funded_travel_requests/1
  # PATCH/PUT /grant_funded_travel_requests/1.json
  def update
    respond_to do |format|
      if @gf_travel_request.update(grant_funded_travel_request_params)
        format.html { redirect_to @gf_travel_request, notice: 'Grant funded travel request was successfully updated.' }
        format.json { render :show, status: :ok, location: @gf_travel_request }
      else
        format.html { render :edit }
        format.json { render json: @gf_travel_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grant_funded_travel_requests/1
  # DELETE /grant_funded_travel_requests/1.json
  def destroy
    @gf_travel_request.destroy
    respond_to do |format|
      format.html { redirect_to @back_path, notice: 'Grant funded travel request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def load_resources
      @user = current_user
      @gf_travel_request = GrantFundedTravelRequest.find(params[:id])
      if current_ability.can?(params[:action].to_sym, @gf_travel_request) && current_user.id != @gf_travel_request.user_id
        @back_path = user_approvals_path(current_user)
      else
        @back_path = user_forms_path(current_user)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grant_funded_travel_request_params
      params.require(:grant_funded_travel_request)
        .permit(:form_user, :form_email, :dest_desc, :business_purpose_desc,
               :business_purpose_url, :business_purpose_other, :depart_date,
               :return_date, :expense_card_use, :expense_card_type, :meal_reimb,
               :traveler_mileage_reimb, :traveler_ground_reimb, :air_use,
               :air_assistance, :ffid, :tsa_pre, :car_rental, :car_assistance,
               :cell_number, :drivers_licence_num, :lodging_reimb,
               :lodging_assistance, :lodging_url, :registration_reimb,
               :registration_assistance, :registration_url, :user_id)
    end
end
