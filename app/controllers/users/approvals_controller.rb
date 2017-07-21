class Users::ApprovalsController < ApplicationController
  before_action :load_user

  def index
    # reviewable = @user.reviewables
    reviewable = ApprovalSearch.by_params(@user, params)
    @approvals = WillPaginate::Collection.create(@page, @per_page, reviewable.length) do |pager|
      pager.replace reviewable
    end
  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end
end
