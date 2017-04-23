class CreatePartyUsers < ActiveRecord::Migration
  def change
    create_table :party_users do |t|
      t.integer :user_id
      t.integer :party_id
      t.references :user
      t.references :party
      t.timestamps null: false
    end
  end
end
