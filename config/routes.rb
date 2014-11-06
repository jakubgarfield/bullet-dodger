Rails.application.routes.draw do
  resources :games, only: [:show, :create] do
    member do
      resources :turns, only: [:show] do
        member do
          resources :player_turns, only: [:create]
        end
      end
    end
  end
end
