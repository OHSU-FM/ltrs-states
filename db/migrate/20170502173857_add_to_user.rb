class AddToUser < ActiveRecord::Migration[5.1]
  def change
    create_table "users", force: :cascade do |t|
      t.string   "email",               limit: 255, default: "", null: false
      t.string   "login",               limit: 255,              null: false
      t.string   "first_name",          limit: 255,              null: false
      t.string   "last_name",           limit: 255,              null: false
    end
  end
end
