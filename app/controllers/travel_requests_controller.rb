class TravelRequestsController < ApplicationController
  before_action :load_resources, only: [:show, :edit, :update, :destroy]
  include StateEvents
  authorize_resource
  skip_authorize_resource only: :update_state

  # GET /travel_requests/1
  # GET /travel_requests/1.json
  def show
    authorize! :show, @travel_request
    if hf_transition_to_in_review?(@travel_request, @user) # defined in StateEvents
      @travel_request.approval_state.review!
    end
  end

  # GET /travel_requests/new
  def new
    @back_path = user_forms_path(current_user)
    @travel_request = TravelRequest.new
    @travel_request.form_user = current_user.full_name
    @travel_request.form_email = current_user.email
  end

  # GET /travel_requests/1/edit
  def edit
  end

  # POST /travel_requests
  # POST /travel_requests.json
  def create
    @travel_request = TravelRequest.new(travel_request_params)
    @travel_request.user = current_user

    respond_to do |format|
      if @travel_request.save
        format.html { redirect_to @travel_request, notice: 'Travel request was successfully created.' }
        format.json { render :show, status: :created, location: @travel_request }
      else
        format.html { render :new }
        format.json { render json: @travel_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /travel_requests/1
  # DELETE /travel_requests/1.json
  def destroy
    @travel_request.destroy
    respond_to do |format|
      format.html { redirect_to @back_path, notice: 'Travel request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_resources
      @user = current_user
      @travel_request = TravelRequest.find(params[:id])
      if current_ability.can?(params[:action].to_sym, @travel_request) && current_user.id != @travel_request.user_id
        @back_path = user_approvals_path(current_user)
      else
        @back_path = user_forms_path(current_user)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def travel_request_params
      params.require(:travel_request)
        .permit(:form_user, :form_email, :dest_desc, :air_use, :air_desc, :ffid,
      :dest_depart_date, :dest_depart_hour, :dest_depart_min, :dest_arrive_hour,
      :dest_arrive_min, :preferred_airline, :menu_notes, :additional_travelers,
      :ret_depart_date, :ret_depart_hour, :ret_depart_min, :ret_arrive_hour,
      :ret_arrive_min, :other_notes, :car_rental, :car_arrive, :car_arrive_hour,
      :car_arrive_min, :car_depart, :car_depart_hour, :car_depart_min,
      :car_rental_co, :lodging_use, :lodging_card_type, :lodging_card_desc,
      :lodging_name, :lodging_phone, :lodging_arrive_date, :lodging_depart_date,
      :lodging_additional_people, :lodging_other_notes, :conf_prepayment,
      :conf_desc, :expense_card_use, :expense_card_type, :expense_card_desc,
      :status, :user_id, :leave_request_id, :mail_sent, :mail_final_sent)
    end
end
