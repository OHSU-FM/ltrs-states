class ChangeGroundTransportColumnToBool < ActiveRecord::Migration[5.1]
  def change
    change_column :grant_funded_travel_requests, :ground_transport, "boolean USING ground_transport::boolean"
  end
end
