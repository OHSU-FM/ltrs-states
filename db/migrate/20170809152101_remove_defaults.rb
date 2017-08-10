class RemoveDefaults < ActiveRecord::Migration[5.1]
  def change
    change_column_default :grant_funded_travel_requests, :other_fmr_attending, nil
    change_column_default :grant_funded_travel_requests, :expense_card_use, nil
    change_column_default :grant_funded_travel_requests, :traveler_mileage_reimb, nil
    change_column_default :grant_funded_travel_requests, :traveler_ground_reimb, nil
    change_column_default :grant_funded_travel_requests, :air_use, nil
    change_column_default :grant_funded_travel_requests, :air_assistance, nil
    change_column_default :grant_funded_travel_requests, :car_rental, nil
    change_column_default :grant_funded_travel_requests, :car_assistance, nil
    change_column_default :grant_funded_travel_requests, :lodging_reimb, nil
    change_column_default :grant_funded_travel_requests, :lodging_assistance, nil
    change_column_default :grant_funded_travel_requests, :registration_reimb, nil
    change_column_default :grant_funded_travel_requests, :registration_assistance, nil
    change_column_default :reimbursement_requests, :other_fmr_attending, nil
    change_column_default :reimbursement_requests, :air_use, nil
    change_column_default :reimbursement_requests, :car_rental, nil
    change_column_default :reimbursement_requests, :meal_host, nil
    change_column_default :reimbursement_requests, :lodging_reimb, nil
    change_column_default :reimbursement_requests, :traveler_mileage_reimb, nil
  end
end
