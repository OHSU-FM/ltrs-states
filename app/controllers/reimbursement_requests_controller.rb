class ReimbursementRequestsController < ApplicationController
  before_action :load_resources, only: [:show, :edit, :update, :destroy]
  include StateEvents
  authorize_resource
  skip_authorize_resource only: [:update_state, :change_per_diem]

  # GET /reimbursement_requests/1
  # GET /reimbursement_requests/1.json
  def show
    authorize! :show, @reimbursement_request
    if hf_transition_to_in_review?(@reimbursement_request, @user) # defined in StateEvents
      @reimbursement_request.approval_state.review!
    end
  end

  # GET /reimbursement_requests/new
  def new
    @reimbursement_request = ReimbursementRequest.new
    @reimbursement_request.form_user = current_user.full_name
    @reimbursement_request.form_email = current_user.email
  end

  # GET /reimbursement_requests/1/edit
  def edit
  end

  # POST /reimbursement_requests
  # POST /reimbursement_requests.json
  def create
    @reimbursement_request = ReimbursementRequest.new(reimbursement_request_params)
    @reimbursement_request.form_user = current_user.full_name
    @reimbursement_request.form_email = current_user.email

    respond_to do |format|
      if @reimbursement_request.save
        format.html { redirect_to @reimbursement_request, notice: 'Reimbursement request was successfully created.' }
        format.json { render :show, status: :created, location: @reimbursement_request }
      else
        format.html { render :new }
        format.json { render json: @reimbursement_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reimbursement_requests/1
  # PATCH/PUT /reimbursement_requests/1.json
  def update
    respond_to do |format|
      if @reimbursement_request.update(reimbursement_request_params)
        format.html { redirect_to @reimbursement_request, notice: 'Reimbursement request was successfully updated.' }
        format.json { render :show, status: :ok, location: @reimbursement_request }
      else
        format.html { render :edit }
        format.json { render json: @reimbursement_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reimbursement_requests/1
  # DELETE /reimbursement_requests/1.json
  def destroy
    @reimbursement_request.destroy
    respond_to do |format|
      format.html { redirect_to user_forms_path(current_user), notice: 'Reimbursement request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def load_resources
      @user = current_user
      @reimbursement_request = ReimbursementRequest.find(params[:id])
      if current_ability.can?(params[:action].to_sym, @reimbursement_request) && current_user.id != @reimbursement_request.user_id
        @back_path = user_approvals_path(current_user)
      else
        @back_path = user_forms_path(current_user)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reimbursement_request_params
      params.require(:reimbursement_request)
        .permit(:form_user, :form_email, :other_fmr_attending, :depart_date,
      :return_date, :air_use, :car_rental, :lodging_reimb,
      :traveler_mileage_reimb, :meal_host_reimb, :user_id,
      :grant_funded_travel_request_id, :meal_na_desc, :additional_info_needed,
      :additional_info_memo, :additional_docs_needed,
      user_files_attributes: [
        :id, :user_file, :uploaded_file, :document_type, :_destroy
      ],
      meal_reimbursement_requests_attributes: [
        :id, :breakfast, :lunch, :dinner, :reimb_date, :_destroy
      ])
    end
end
