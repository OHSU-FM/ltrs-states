class AddOptionalsToGftr < ActiveRecord::Migration[5.1]
  def change
    add_column :grant_funded_travel_requests, :additional_info_needed, :boolean
    add_column :grant_funded_travel_requests, :additional_info_memo, :text
    add_column :grant_funded_travel_requests, :additional_docs_needed, :boolean
  end
end
