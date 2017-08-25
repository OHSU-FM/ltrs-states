class UsersController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def update
    @user.update(user_params)
  end

  def ldap_search
    scanner = LdapQuery::Scanner.search params[:q]
    @ude = scanner.as_ude_attributes
    @ude[:errors] = scanner.errors
    respond_to do |format|
      format.json {render :json => @ude }
    end
  end

  private
  def user_params
    params.require(:user).permit(:dob, :cell_number, :travel_email, :ecn1,
                                 :ecp1, :ecn2, :ecp2, :dietary_restrictions,
                                 :ada_accom, :air_seat_pref, :hotel_room_pref,
                                 :tsa_pre, ff_numbers_attributes: [
                                   :id, :airline, :ffid, :_destroy
                                 ], user_approvers_attributes: [
                                   :id, :approver_id, :approver_type,
                                   :approval_order, :_destroy])
  end
end
