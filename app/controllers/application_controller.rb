class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # check if a user has a session; if not create one.

  def create_session
    @user = User.new(:nickname => User.temp_user_name)
    session[:user_id] = @user.id
    @user.save
    @user
  end

  helper_method def session_exists?
    !session[:user_id].nil?
  end

  helper_method def db_user_exists?
    User.exists?(session[:user_id])
  end

  helper_method def current_user
    if session_exists? && db_user_exists?
      p session[:user_id]
      User.find(session[:user_id])
    else
      p 'creating new'
      create_session
    end
  end
end
