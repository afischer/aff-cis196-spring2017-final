class WelcomeController < ApplicationController
  # GET /
  def index
    @party = Party.new
    render :'welcome/index.html.erb'
  end
end
