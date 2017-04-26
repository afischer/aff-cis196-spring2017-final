class Party < ActiveRecord::Base
  has_many :songs, dependent: :destroy
  has_many :party_users
  has_many :users, through: :party_users

  def current_song
    return nil if current_song_id.nil?
    Song.find(current_song_id)
  end

  def sorted_songs
    songs.sort_by(&:score).reverse!
  end
end
