class AddTravelProfileFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :dob, :date
    add_column :users, :cell_number, :string
    add_column :users, :travel_email, :string
    add_column :users, :ecn1, :string
    add_column :users, :ecp1, :string
    add_column :users, :ecn2, :string
    add_column :users, :ecp2, :string
    add_column :users, :dietary_restrictions, :text
    add_column :users, :ada_accom, :text
    add_column :users, :air_seat_pref, :string
    add_column :users, :hotel_room_pref, :text
    add_column :users, :tsa_pre, :string
  end
end
