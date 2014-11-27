Rails.application.routes.draw do
  apipie
  resources :games, only: [:show, :create] do
    resources :turns, only: [:show] do
      resources :player_turns, only: [:create]
    end
  end

  root to: 'apipie/apipies#index'
end
