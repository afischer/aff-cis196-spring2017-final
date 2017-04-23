class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name
      t.references :current_song, index: true, foreign_key: { to_table: :songs }
      t.integer :dj_id
      t.timestamps null: false
    end
  end
end
