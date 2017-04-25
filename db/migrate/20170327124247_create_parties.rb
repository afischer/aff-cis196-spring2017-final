class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name
      t.integer :current_song_id
      t.integer :dj_id
      t.timestamps null: false
    end
  end
end
