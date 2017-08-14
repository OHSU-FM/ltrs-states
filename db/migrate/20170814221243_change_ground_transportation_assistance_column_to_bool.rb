class ChangeGroundTransportationAssistanceColumnToBool < ActiveRecord::Migration[5.1]
  def change
    change_column :grant_funded_travel_requests, :ground_transport_assistance, "boolean USING ground_transport_assistance::boolean"
  end
end
