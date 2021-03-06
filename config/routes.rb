Rails.application.routes.draw do
  get '/' => 'welcome#index'
  get '/about' => 'welcome#about'

  resources :parties
  post '/parties/:id/play/:song_id' => 'parties#play_song'
  post '/parties/:id/next/' => 'parties#play_next'

  resources :songs
  post '/parties/:id/songs/:song_id/upvote' => 'songs#upvote'
  post '/parties/:id/songs/:song_id/downvote' => 'songs#downvote'

  resources :users
end
