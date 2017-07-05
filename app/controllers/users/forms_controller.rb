class Users::FormsController < ApplicationController
  before_action :load_user

  def index
    approvables = @user.approvables
    @approvables = WillPaginate::Collection.create(@page, @per_page, approvables.length) do |pager|
      pager.replace approvables
    end
    respond_to do |format|
      format.html # forms.html.erb
      format.json {render :json => @approvals }
    end
  end

  def delegate_forms
    @approvables = nil
    respond_to do |format|
      format.html {render template: 'users/forms/index'}
      format.json {render :json => @approvals }
    end
  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end
end
