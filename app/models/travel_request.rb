class TravelRequest < ApplicationRecord
  belongs_to :leave_request
  belongs_to :user

  has_many :travel_files, dependent: :destroy, inverse_of: :travel_request
  has_many :user_files, through: :travel_files, dependent: :destroy
  has_one :approval_state, as: :approvable, dependent: :destroy


  validates_associated :approval_state
  validates_presence_of :dest_depart_date,
    :ret_depart_date,
    :form_email,
    :form_user,
    :user

  accepts_nested_attributes_for :approval_state, allow_destroy: true
  accepts_nested_attributes_for :travel_files, allow_destroy: true
  accepts_nested_attributes_for :user_files, allow_destroy: true
end
