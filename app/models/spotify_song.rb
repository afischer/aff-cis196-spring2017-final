class SpotifySong < Song
  validates :title, presence: true

  SPOTIFY_BASE_URL = 'https://api.spotify.com/v1/search?q='.freeze

  def song_search
    title.tr(' ', '+')
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
    details = JSON.parse(open(spotify_endpoint).read)['tracks']['items'].first
    save_meta(details)
  end

  def save_meta(details)
    self.title = details['name']
    self.artist = details['artists'].first['name']
    self.album = details['album']['name']
    # might want to get both small and large art, this is usually 500x500
    self.album_art = details['album']['images'].first['url']
    self.duration = details['duration_ms']
    self.source = 'Spotify'
    self.uri = details['uri']
    save
  end
end
