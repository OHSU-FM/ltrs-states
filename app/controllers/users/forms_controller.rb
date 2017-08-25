class Users::FormsController < ApplicationController
  before_action :load_user

  def index
    redirect_to root_path if (@user != current_user and !current_user.is_admin?)

    approvables = @user.approvables
    @approvables = WillPaginate::Collection.create(@page, @per_page, approvables.length) do |pager|
      pager.replace approvables
    end

    respond_to do |format|
      format.html # forms.html.erb
      format.json { render :json => @approvals }
    end
  end

  def delegate_forms
    approvables = ApprovalSearch.delegator_approvables_for @user
    @approvables = WillPaginate::Collection.create(@page, @per_page, approvables.length) do |pager|
      pager.replace approvables
    end

    respond_to do |format|
      format.html { render template: 'users/forms/index'}
      format.json { render json: @approvals }
    end
  end

  private

  def load_user
    @user = User.find params[:user_id]
  end
end
