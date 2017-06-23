class LeaveRequestsController < ApplicationController
  include StateEvents
  before_action :set_leave_request, only: [:show, :edit, :update, :destroy]

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

  # GET /leave_requests/1/edit
  def edit
  end

  # POST /leave_requests
  # POST /leave_requests.json
  def create
    @leave_request = LeaveRequest.new(leave_request_params)

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

  # PATCH/PUT /leave_requests/1
  # PATCH/PUT /leave_requests/1.json
  def update
    @leave_request.assign_attributes(leave_request_params)
    if @leave_request.changed?
      respond_to do |format|
        if @leave_request.update(leave_request_params)
          @leave_request.approval_state.unsubmit!
          format.html { redirect_to @leave_request, notice: 'Leave request was successfully updated.' }
          format.json { render :show, status: :ok, location: @leave_request }
        else
          format.html { render :edit }
          format.json { render json: @leave_request.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html  { redirect_to @leave_request, notice: 'Nothing changed, so no emails were sent.' }
        format.json  { render :show, status: :ok, location: @leave_request }
      end
    end
  end

  # DELETE /leave_requests/1
  # DELETE /leave_requests/1.json
  def destroy
    @leave_request.destroy
    respond_to do |format|
      format.html { redirect_to leave_requests_url, notice: 'Leave request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leave_request
      @leave_request = LeaveRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leave_request_params
      params.require(:leave_request).permit(:user_id, :start_date)
    end
end
