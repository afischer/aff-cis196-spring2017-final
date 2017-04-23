class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :album
      t.string :album_art
      t.integer :duration
      t.integer :playlist_position
      t.integer :score
      t.timestamps null: false
      t.string :source
      t.references :party
    end
  end
end
