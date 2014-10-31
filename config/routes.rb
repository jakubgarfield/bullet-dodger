Rails.application.routes.draw do
  #get "/game/:id", to: "games#show"
  #post "/games/join", to: "games#join"

  #get "/game/:game_id/turn/:turn_id/", to: "turns#show"
  #post "/game/:game_id/turn/:turn_id/player_turns", to: "player_turns#create"

  resources :games, only: [:show, :create] do
    member do
      resources :turns, only: [:show]
      resources :player_turns, only: [:create]
    end
  end
end
