require 'sessions_controller.rb'
class PartiesController < ApplicationController
  before_action :set_party, only: %i(show edit update destroy play_song)

  # GET /parties
  def index
    @parties = Party.all
  end

  # GET /parties/1
  def show
    @party.users << current_user unless @party.users.include? current_user
  end

  # GET /parties/new
  def new
    @party = Party.new
  end

  # GET /parties/1/edit
  def edit; end

  # POST /parties
  def create
    @party = Party.new(party_params)
    @party.dj_id = current_user.id
    if @party.save
      @party.users << current_user unless @party.users.include? current_user
      redirect_to @party, notice: 'Party was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /parties/1
  def update
    if @party.update(party_params)
      redirect_to @party, notice: 'Party was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /parties/1
  def destroy
    @party.destroy
    redirect_to parties_url, notice: 'Party was successfully destroyed.'
  end

  def play_song
    @party = Party.find(params[:id])
    song = Song.find(params[:song_id])
    return redirect_to @party, notice: 'Song does not exist.' if song.nil?
    return redirect_to @party, notice: 'Song not in playlist.' unless @party.songs.include? song
    @party.current_song_id = song.id
    @party.save
    redirect_to @party, notice: "Now playing #{song.title} by #{song.artist}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_party
    @party = Party.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def party_params
    params.require(:party).permit(:name, :current_song)
  end
end
