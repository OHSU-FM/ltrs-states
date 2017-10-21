class ChangeFlightSeatPrefOnGfTravelRequests < ActiveRecord::Migration[5.1]
  def change
    rename_column :grant_funded_travel_requests, :flight_seat_pref, :air_seat_pref
  end
end
