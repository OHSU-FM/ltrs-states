class RemoveFromFundingSources < ActiveRecord::Migration[5.1]
  def change
    remove_column :ff_numbers, :string, :string
    remove_column :funding_sources, :nickname, :string
    remove_column :funding_sources, :award_number, :string
  end
end
