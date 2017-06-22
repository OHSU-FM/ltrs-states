class UsersController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def update
    @user.update(user_params)
  end

  def ldap_search
    byebug
    scanner = LdapQuery::Scanner.search params[:q]
    @ude = scanner.as_ude_attributes
    @ude[:errors] = scanner.errors
    respond_to do |format|
      format.json {render :json => @ude }
    end
  end

  private
  def user_params
    params.require(:user).permit(user_approvers_attributes: [
      :id, :approver_id, :approver_type, :approval_order, :_destroy
    ])
  end
end
