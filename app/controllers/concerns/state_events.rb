module StateEvents
  extend ActiveSupport::Concern

  included do
    before_action :set_approvable_and_state, only: [:submit]
    helper_method :submit
  end

  def submit
    respond_to do |format|
      if @approval_state.submit
        format.html { redirect_to @approvable, notice: "#{@approvable.model_name.human} was successfully updated." }
        format.json { render :show, status: :ok, location: @leave_request }
      else
        # TODO better error
        format.html { render :show, notice: "Sorry something's gone wrong" }
        format.json { render json: @approvable.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_approvable_and_state
    @approvable = params[:controller].classify.constantize.find(params[:id])
    @approval_state = @approvable.approval_state
  end
end
