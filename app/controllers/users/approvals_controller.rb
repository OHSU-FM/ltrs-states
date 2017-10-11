class Users::ApprovalsController < ApplicationController
  before_action :load_user

  def index
    redirect_to root_path unless (current_user.is_admin? || current_user == @user)
    reviewable = ApprovalSearch.by_params(@user, params)
    @approvals = WillPaginate::Collection.create(@page, @per_page, reviewable.length) do |pager|
      pager.replace reviewable[pager.offset, pager.per_page].to_a
    end
  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end
end
