class MealReimbursementRequest < ApplicationRecord
  belongs_to :reimbursement_request, inverse_of: :meal_reimbursement_requests

  validates_presence_of :reimb_date
end
