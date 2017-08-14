class CreateFfNumbers < ActiveRecord::Migration[5.1]
  def change
    create_table :ff_numbers do |t|
      t.string :ffid
      t.string :string
      t.string :airline
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
