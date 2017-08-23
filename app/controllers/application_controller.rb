class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!

  append_before_action :check_for_pagination, only: [:index, :delegate_forms]

  PAGE     = 1
  PER_PAGE = 10

  rescue_from CanCan::AccessDenied do |e|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: e.message }
    end
  end

  private

  def check_for_pagination
    @page = params[:page] || PAGE
    @per_page = params[:per_page] || PER_PAGE
  end
end
