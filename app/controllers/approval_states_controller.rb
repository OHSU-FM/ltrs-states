class ApprovalStatesController < ApplicationController
  before_action :set_approval_state, only: [:show, :edit, :update, :destroy]

  # GET /approval_states/new
  def new
    @approval_state = ApprovalState.new
  end

  # GET /approval_states/1/edit
  def edit
  end

  # POST /approval_states
  # POST /approval_states.json
  def create
    @approval_state = ApprovalState.new(approval_state_params)

    respond_to do |format|
      if @approval_state.save
        format.html { redirect_to @approval_state, notice: 'Approval state was successfully created.' }
        format.json { render :show, status: :created, location: @approval_state }
      else
        format.html { render :new }
        format.json { render json: @approval_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /approval_states/1
  # PATCH/PUT /approval_states/1.json
  def update
    respond_to do |format|
      if @approval_state.update(approval_state_params)
        format.html { redirect_to @approval_state, notice: 'Approval state was successfully updated.' }
        format.json { render :show, status: :ok, location: @approval_state }
      else
        format.html { render :edit }
        format.json { render json: @approval_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /approval_states/1
  # DELETE /approval_states/1.json
  def destroy
    @approval_state.destroy
    respond_to do |format|
      format.html { redirect_to approval_states_url, notice: 'Approval state was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_approval_state
      @approval_state = ApprovalState.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def approval_state_params
      params.fetch(:approval_state, {})
    end
end
