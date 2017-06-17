class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |e|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: e.message }
    end
  end
end
