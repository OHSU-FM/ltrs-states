module StateEvents
  extend ActiveSupport::Concern
  include Concerns::StateEventsHelper

  included do
    before_action :set_approvable_and_state,
      only: [:update_state, :submit, :send_to_unopened, :review, :reject, :accept]
  end

  def update_state
    send params[:approval_state][:aasm_state]
    respond_to do |format|
      format.js
      format.html
    end
  end

  def submit
    authorize! :submit, @approvable
    respond_to do |format|
      if @approval_state.may_submit?
        if @approvable.ready_for_submission? && @approval_state.submit!
          UserMailer.request_submitted(@approval_state).deliver_now
          if @approval_state.may_send_to_unopened? && @approval_state.send_to_unopened!
            format.html { redirect_to @approvable,
                          notice: "#{@approvable.model_name.human} was successfully submitted." }
            format.json { render json: @approvable, status: :ok, location: @approvable }
          end
        else
          @approvable.errors.full_messages.each{|m| flash[:error] = m }
          format.html { redirect_to @approvable }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @approvable, notice: "This request has already been submitted, so nothing happened." }
      end
    end
  end

  def review
    authorize! :review, @approvable
    respond_to do |format|
      if @approval_state.may_review?
        if @approval_state.review!
          format.html { redirect_to @approvable,
                        notice: "#{@approvable.model_name.human} was successfully reviewed." }
          format.json { render json: @approvable, status: :ok, location: @approvable }
        else
          format.html { redirect_to @approvable, alert: "Request was unable to be reviewed" }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @approvable, notice: "This request has already been opened, so nothing happened." }
      end
    end
  end

  def reject
    authorize! :reject, @approvable
    respond_to do |format|
      if @approval_state.may_reject?
        if @approval_state.reject!
          UserMailer.request_rejected(@approval_state).deliver_now
          format.html { redirect_to @approvable,
                        notice: "#{@approvable.model_name.human} was successfully rejected." }
          format.json { render json: @approvable, status: :ok, location: @approvable }
        else
          format.html { redirect_to @approvable, alert: "Request was unable to be rejected" }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @approvable, notice: "This request has already been rejected, so nothing happened." }
      end
    end
  end

  def accept
    authorize! :accept, @approvable
    respond_to do |format|
      if @approval_state.next_user_approver.reviewer? and @approval_state.may_send_to_unopened?
        if @approval_state.send_to_unopened!
          UserMailer.request_first_reviewer_accepted(@approval_state).deliver_now
          format.html { redirect_to @approvable,
                        notice: "#{@approvable.model_name.human} was successfully sent to the next approver." }
          format.json { render :show, status: :ok, location: @approvable }
        else
          format.html { redirect_to @approvable, alert: "Request failed to be sent to the next reviewer" }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      elsif @approval_state.may_accept?
        if @approval_state.accept!
          if @approvable.is_a? GrantFundedTravelRequest
            build_reimbursement_request_for @approval_state.user, @approvable
            UserMailer.reimbursement_request_available(@approval_state).deliver_now
          end
          UserMailer.request_accepted(@approval_state).deliver_now
          format.html { redirect_to @approvable,
                        notice: "#{@approvable.model_name.human} was successfully accepted." }
          format.json { render json: @approvable, status: :ok, location: @approvable }
        else
          format.html { redirect_to @approvable, alert: "Request was unable to be accepted" }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @approvable, notice: "This request has already been accepted, so nothing happened." }
      end
    end
  end

  private

  def build_reimbursement_request_for u, tr
    ReimbursementRequest.create!(user: u,
                                 gf_travel_request: tr,
                                 depart_date: tr.depart_date,
                                 return_date: tr.return_date,
                                 form_user: tr.form_user,
                                 form_email: tr.form_email)
  end

  def set_approvable_and_state
    @approvable = params[:controller].classify.constantize.find(params[:id])
    @approval_state = @approvable.approval_state
  end
end
