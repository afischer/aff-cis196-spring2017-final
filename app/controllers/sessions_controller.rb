class SessionsController < ApplicationController
  # def self.create
  #   session[:user_id] = @user.id unless @user.nil? || session[:user_id].any?
  # end

  # def registered?
  #   session[:user_id].any?
  # end

  def current_user
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end
end
