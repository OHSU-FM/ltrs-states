class ChangeColumnInGrantFundedTravelRequests < ActiveRecord::Migration[5.1]
  def change
    change_column :grant_funded_travel_requests, :meal_reimb, 'boolean USING CAST(meal_reimb as boolean)'
  end
end
