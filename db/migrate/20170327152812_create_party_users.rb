class CreatePartyUsers < ActiveRecord::Migration
  def change
    create_table :party_users do |t|
      t.boolean :is_dj

      t.timestamps null: false
    end
  end
end
