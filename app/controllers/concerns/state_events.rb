module StateEvents
  extend ActiveSupport::Concern

  included do
    before_action :set_approvable_and_state,
      only: [:update_state, :submit, :send_to_unopened, :review, :reject, :accept]
  end

  def update_state
    send params[:approval_state][:aasm_state]
  end

  def submit
    respond_to do |format|
      if @approval_state.may_submit?
        if @approval_state.submit!
          UserMailer.request_submitted(@approval_state).deliver_now
          if @approval_state.may_send_to_unopened? && @approval_state.send_to_unopened!
            format.html { redirect_to @approvable,
                          notice: "#{@approvable.model_name.human} was successfully submitted." }
            format.json { render :show, status: :ok, location: @approvable }
          end
        else
          # TODO better error
          format.html { redirect_to @approvable, notice: "Sorry something's gone wrong" }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @approvable,
                      notice: "This request has already been submitted, so nothing happened." }
      end
    end
  end

  def send_to_unopened
    respond_to do |format|
      if @approval_state.may_send_to_unopened?
        if @approval_state.send_to_unopened!
          format.html { redirect_to @approvable,
                        notice: "#{@approvable.model_name.human} was successfully sent_to_unopened." }
          format.json { render :show, status: :ok, location: @approvable }
        else
          format.html { redirect_to @approvable, notice: "Sorry something's gone wrong" }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @approvable,
                      notice: "This request has already been sent to the reviewer, so nothing happened." }
      end
    end
  end

  def review
    respond_to do |format|
      if @approval_state.may_review?
        if @approval_state.review!
          format.html { redirect_to @approvable,
                        notice: "#{@approvable.model_name.human} was successfully reviewed." }
          format.json { render :show, status: :ok, location: @approvable }
        else
          format.html { redirect_to @approvable, notice: "Sorry something's gone wrong" }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @approvable,
                      notice: "This request has already been opened, so nothing happened." }
      end
    end
  end

  def reject
    respond_to do |format|
      if @approval_state.may_reject?
        if @approval_state.reject!
          UserMailer.request_rejected(@approval_state).deliver_now
          format.html { redirect_to @approvable,
                        notice: "#{@approvable.model_name.human} was successfully rejected." }
          format.json { render :show, status: :ok, location: @approvable }
        else
          format.html { redirect_to @approvable, notice: "Sorry something's gone wrong" }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @approvable,
                      notice: "This request has already been rejected, so nothing happened." }
      end
    end
  end

  def accept
    respond_to do |format|
      if @approval_state.next_user_approver.reviewer? and @approval_state.may_send_to_unopened?
        if @approval_state.send_to_unopened!
          # TODO mailer
          # UserMailer.request_accepted(@approval_state).deliver_now
          format.html { redirect_to @approvable,
                        notice: "#{@approvable.model_name.human} was successfully sent to the next approver." }
          format.json { render :show, status: :ok, location: @approvable }
        else
          format.html { redirect_to @approvable, notice: "Sorry something's gone wrong" }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      elsif @approval_state.may_accept?
        if @approval_state.accept!
          UserMailer.request_accepted(@approval_state).deliver_now
          format.html { redirect_to @approvable,
                        notice: "#{@approvable.model_name.human} was successfully accepted." }
          format.json { render :show, status: :ok, location: @approvable }
        else
          format.html { redirect_to @approvable, notice: "Sorry something's gone wrong" }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @approvable,
                      notice: "This request has already been accepted, so nothing happened." }
      end
    end
  end

  # Should this record.approval_state be sent the review event?
  #
  # compares state of a request with a user to see if record is in the unopened
  # state and the use is the next_user_approver. if so, return true, else false
  #
  # @param record [LeaveRequest || TravelRequest]
  # @param user [User]
  # @return [Boolean] whether record should be sent review transition
  def hf_transition_to_in_review? record, user
    if record.approval_state.unopened?
      if record.next_user_approver.approver == user &&
          record.approval_state.may_review?
        true
      else
        false
      end
    end
  end

  private

  def set_approvable_and_state
    @approvable = params[:controller].classify.constantize.find(params[:id])
    @approval_state = @approvable.approval_state
  end
end
