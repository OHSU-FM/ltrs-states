module StateEvents
  extend ActiveSupport::Concern

  included do
    before_action :set_approvable, only: [:submit]
    helper_method :submit
  end

  def submit
    byebug
  end

  private

  def set_approvable
    @approvable = params[:controller].classify.constantize.find(params[:id])
  end
end
