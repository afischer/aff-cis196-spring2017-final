class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  # GET /songs
  def index
    @songs = Song.all
  end

  # GET /songs/1
  def show; end

  # GET /songs/new
  def new
    @song = Song.new
  end

  # GET /songs/1/edit
  def edit; end

  # POST /songs
  def create
    p params
    @party = Party.find(params['song']['party_id']) unless params['song']['party_id'].nil?
    @song = SpotifySong.new(title: params['song']['title'])
    if @song.in_spotify?
      @song.add_details
      notice = 'Song was successfully created.'
      res = true
    else
      notice = 'Song creation failed.'
      res = false
      return false
    end
    @song.party = @party unless @party.nil? || @party.songs.include?(@song)
    @song.save
    return redirect_to @party, notice: notice unless @party.nil?
    render 'songs/show', notice: notice # FIXME: Notices not working
    res
  end

  # PATCH/PUT /songs/1
  def update
    if @song.update(song_params)
      redirect_to @song, notice: 'Song was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /songs/1
  def destroy
    @song.destroy
    redirect_to songs_url, notice: 'Song was successfully destroyed.'
  end

  def upvote
    @party = Party.find(params[:id])
    song = Song.find(params[:song_id])
    song.score += 1
    redirect_to @party, notice: 'Upvoted!'
  end

  def downvote
    @party = Party.find(params[:id])
    song = Song.find(params[:song_id])
    song.score -= 1
    song.save
    redirect_to @party, notice: 'Downvoted!'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_song
    @song = Song.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def song_params
    params.require(:song).permit(:title, :artist, :album, :album_art, :duration)
  end
end
