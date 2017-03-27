class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name
      t.string :current_song_id

      t.timestamps null: false
    end
  end
end