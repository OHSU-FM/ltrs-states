class UsersController < ApplicationController
  load_and_authorize_resource except: [:travel_profile]
  include Concerns::UsersControllerHelper

  def show
  end

  def update
    if @user.update(user_params)
      respond_to do |format|
        format.html
        format.js { flash.now[:success] = "Successfully updated" }
      end
    else
      respond_to do |format|
        format.html
        format.js { flash.now[:error] = @user.errors.full_messages.to_sentence }
      end
    end
  end

  def search
    @users = User.where("last_name like ?", "%#{params[:term]}%").or
      .where("first_name like ?", "%#{params[:term]}%").or
      .where("login like ?", "%#{params[:term]}%").or
      .where("email like ?", "%#{params[:term]}%")
    render json: @users.map(&:id)
  end

  def travel_profile
    user_id = params[:user_id]
    if hf_can_read_profile? current_user, user_id
      profile = User.find(user_id).form_travel_profile

      respond_to do |format|
        format.json { render json: { travel_profile: profile } }
      end
    else
      respond_to do |format|
        format.js { flash.now[:error] = "Sorry something's gone wrong" }
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:empid, :emp_class, :emp_home, :dob,
                                 :password, :password_confirmation, :timezone,
                                 :cell_number, :ecn1, :ecp1, :ecn2, :ecp2,
                                 :dietary_restrictions, :ada_accom,
                                 :air_seat_pref, :hotel_room_pref, :tsa_pre,
                                 :legal_name,
                                 ff_numbers_attributes: [ :id, :airline, :ffid,
                                                          :_destroy ],
                                 user_approvers_attributes: [ :id, :approver_id,
                                                              :approver_type,
                                                              :approval_order,
                                                              :_destroy])
  end
end
