class WelcomeController < ApplicationController
  # GET /
  def index
    render :'welcome/index.html.erb'
  end
end
