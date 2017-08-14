class CreateFundingSources < ActiveRecord::Migration[5.1]
  def change
    create_table :funding_sources do |t|
      t.string :pi
      t.string :title
      t.string :nickname
      t.string :award_number
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
