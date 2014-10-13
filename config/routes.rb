Rails.application.routes.draw do
  get "/game/:id", to: "games#show"
  get "/games/join", to: "games#join"

  post "/game/:game_id/turn/:id", to: "turns#show"

  post "game/:game_id/player_turns", to: "player_turns#create"
end
