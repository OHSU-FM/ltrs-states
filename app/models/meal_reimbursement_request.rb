class MealReimbursementRequest < ApplicationRecord
  belongs_to :reimbursement_request, inverse_of: :meal_reimbursement_requests

  validates_presence_of :reimb_date

  def has_na?
    [breakfast, lunch, dinner].include? false
  end
end
