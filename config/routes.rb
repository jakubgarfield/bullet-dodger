Rails.application.routes.draw do
  apipie
  resources :games, only: [:show, :create, :index] do
    resources :turns, only: [:show] do
      resources :player_turns, only: [:create]
    end
  end

  root to: 'games#index'
end
