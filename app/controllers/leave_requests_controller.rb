class LeaveRequestsController < ApplicationController
  include StateEvents
  before_action :load_resources, only: [:show, :edit, :update, :destroy]

  # GET /leave_requests
  # GET /leave_requests.json
  def index
    @leave_requests = LeaveRequest.paginate(page: @page, per_page: @per_page)
      .order('created_at DESC')
  end

  # GET /leave_requests/1
  # GET /leave_requests/1.json
  def show
    # TODO open event if current_user if next_user_approver
  end

  # GET /leave_requests/new
  def new
    @back_path = user_forms_path(current_user)
    @leave_request = LeaveRequest.new
    if params.has_key?(:extra) and params[:extra] == 'true'
      @leave_request.build_leave_request_extra
      @leave_request.has_extra = true
    end
  end

  # POST /leave_requests
  # POST /leave_requests.json
  def create
    @leave_request = LeaveRequest.new(leave_request_params)
    @leave_request.form_user = current_user.full_name
    @leave_request.form_email = current_user.email

    respond_to do |format|
      if @leave_request.save
        format.html { redirect_to @leave_request, notice: 'Leave request was successfully created.' }
        format.json { render :show, status: :created, location: @leave_request }
      else
        format.html { render :new }
        format.json { render json: @leave_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leave_requests/1
  # DELETE /leave_requests/1.json
  def destroy
    @leave_request.destroy
    respond_to do |format|
      format.html { redirect_to @back_path, notice: 'Leave request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_resources
      @user = current_user
      @leave_request = LeaveRequest.includes(:leave_request_extra, :travel_request).find(params[:id])
      if current_ability.can?(params[:action].to_sym, @leave_request) && current_user.id != @leave_request.user_id
        @back_path = user_approvals_path(current_user)
      else
        @back_path = user_forms_path(current_user)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leave_request_params
      params.require(:leave_request)
        .permit(:user_id, :start_date, :form_user, :form_email, :start_hour,
      :start_min, :end_date, :end_hour, :end_min, :desc, :hours_vacation,
               :hours_sick, :hours_other, :hours_other_desc, :hours_training,
               :hours_training_desc, :hours_comp, :hours_comp_desc, :hours_cme,
               :need_travel, :mail_sent, :mail_final_sent)
    end
end
