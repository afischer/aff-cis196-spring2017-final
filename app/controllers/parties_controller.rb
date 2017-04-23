require 'sessions_controller.rb'
class PartiesController < ApplicationController
  before_action :set_party, only: [:show, :edit, :update, :destroy]

  # GET /parties
  def index
    @parties = Party.all
  end

  # GET /parties/1
  def show
  end

  # GET /parties/new
  def new
    @party = Party.new
  end

  # GET /parties/1/edit
  def edit
  end

  # POST /parties
  def create
    @party = Party.new(party_params)
    if session[:user_id].nil?
      @user = User.new(:nickname => temp_user_name)
      session[:user_id] = @user.id if @user.save
      # TODO: ERROR HANDLE THIS
    else
      @user = current_user
    end
    @party.dj_id = @user.id
    if @party.save
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

  private

  def temp_user_name
    "User #{SecureRandom.uuid[0, 5]}"
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_party
    @party = Party.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def party_params
    params.require(:party).permit(:name, :current_song_id)
  end
end
