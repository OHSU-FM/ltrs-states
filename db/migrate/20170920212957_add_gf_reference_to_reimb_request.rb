class AddGfReferenceToReimbRequest < ActiveRecord::Migration[5.1]
  def change
    add_reference :reimbursement_requests, :grant_funded_travel_request, foreign_key: true
  end
end
