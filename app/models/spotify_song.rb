class SpotifySong < Song
  validates :title, presence: true, uniqueness: true

  SPOTIFY_BASE_URL = 'https://api.spotify.com/v1/search?q='.freeze

  def song_search
    song_name = title.tr(' ', '+')
    artist_name = artist.tr(' ', '+')
    "#{song_name}+#{artist_name}"
  end

  def spotify_uri
    return nil unless in_spotify?
    search_params = song_search
    spotify_endpoint = "#{SPOTIFY_BASE_URL}#{search_params}&type=track"
    json = JSON.parse(open(spotify_endpoint).read)
    return json['tracks']['items'].first['uri'] if json['tracks']['items'].any?
  end

  def in_spotify?
    search_params = song_search
    spotify_endpoint = "#{SPOTIFY_BASE_URL}#{search_params}&type=track"
    json = JSON.parse(open(spotify_endpoint).read)
    return true if json['tracks']['items'].any?
    false
  end

  def add_details
    search_params = song_search
    spotify_endpoint = "#{SPOTIFY_BASE_URL}#{search_params}&type=track"
    p spotify_endpoint
    details = JSON.parse(open(spotify_endpoint).read)['tracks']['items'].first
    save_meta(details)
  end

  def save_meta(details)
    self.title = details['name']
    p "title is #{title}"
    self.artist = details['artists'].first['name']
    p "artist is #{artist}"
    self.album = details['album']['name']
    p "alb is #{album}"

    self.album_art = details['album']['images'].first['url']
    p "art is #{album_art}"

    self.duration = details['duration_ms']
    p "duration is #{duration}"
    save
  end
end
