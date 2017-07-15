class CreateTravelFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :travel_files do |t|
      t.references :travel_request, foreign_key: true
      t.references :user_file, foreign_key: true
    end
  end
end
