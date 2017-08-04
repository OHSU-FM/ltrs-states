class AddToGfTravelRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :grant_funded_travel_requests, :rental_needs_desc, :text
    add_column :grant_funded_travel_requests, :ground_transport, :text
    add_column :grant_funded_travel_requests, :ground_transport_assistance, :text
    add_column :grant_funded_travel_requests, :ground_transport_desc, :text
    add_column :grant_funded_travel_requests, :flight_airline, :string
    add_column :grant_funded_travel_requests, :flight_seat_pref, :string
  end
end
