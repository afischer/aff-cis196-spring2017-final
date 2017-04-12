class SessionsControllerController < ApplicationController
  def create
    @user = User.find_by(name: params[:name])
    if @user.nil? || params[:name].nil?
      redirect_to '/'
    else
      session[:user_id] = @user.id
      # redirect_to @party
    end
  end
end
