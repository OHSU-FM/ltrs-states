module StateEvents
  extend ActiveSupport::Concern

  included do
    before_action :set_approvable_and_state, only: [:submit, :send_to_unopened]
    helper_method :submit
  end

  def submit
    respond_to do |format|
      UserMailer.request_submitted(@approval_state).deliver_now
      if @approval_state.may_submit?
        if @approval_state.submit!

          format.html { redirect_to @approvable, notice: "#{@approvable.model_name.human} was successfully submitted." }
          format.json { render :show, status: :ok, location: @approvable }
        else
          # TODO better error
          format.html { redirect_to @approvable, notice: "Sorry something's gone wrong" }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @approvable, notice: "This request has already been submitted, so nothing happened." }
      end
    end
  end

  def send_to_unopened
    respond_to do |format|
      if @approval_state.may_send_to_unopened?
        if @approval_state.send_to_unopened!
          format.html { redirect_to @approvable, notice: "#{@approvable.model_name.human} was successfully sent_to_unopened." }
          format.json { render :show, status: :ok, location: @approvable }
        else
          format.html { redirect_to @approvable, notice: "Sorry something's gone wrong" }
          format.json { render json: @approvable.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @approvable, notice: "This request has already been sent to the reviewer, so nothing happened." }
      end
    end
  end

  private

  def set_approvable_and_state
    @approvable = params[:controller].classify.constantize.find(params[:id])
    @approval_state = @approvable.approval_state
  end
end
