class WelcomeController < ApplicationController
  # GET /
  def index
    @party = Party.new
    render :'welcome/index.html.erb'
  end

  # GET /about
  def about
    render :'welcome/about.html.erb'
  end
end
