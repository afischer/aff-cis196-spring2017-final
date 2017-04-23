class Party < ActiveRecord::Base
  has_many :songs
  has_many :party_users
  has_many :users, through: :party_users

  def add_song(song)
    p 'SONG SONG SONG SONG'
    p song
    # songs << song
  end
end
