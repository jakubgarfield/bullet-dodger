class GamesController < ApplicationController
  resource_description do
    description "It is used to receive a state of a particular game or if you want to join a new game."
  end

  api :GET, "/games/:id", "Returns a state of the game with a current turn and possibly both players and winner."
  description <<-eos
The method is used for getting the state of the game and it is intended for use with polling request.

In general, it returns a json with a game state that looks like this
  {
    id: 1,
    state: "waiting_for_players"
  }
but there are other cases. Firstly, the states of the game might be
* running,
* waiting_for_players,
* timed_out
* or finished.

The last two are terminal states and in that case there might be a winner.
  {
    id: 1,
    state: "finished"
    current_turn { id: 5 },
    players:
    {
      { id: 2, name: "Jonathan" },
      { id: 3, name: "Jon" },
    },
    winner: { id: 3 }
  }
eos
  def show
    game = Game.find(params[:id])
    render json: GameJsonPresenter.new(game).to_json
  end

  api :POST, "/games", "Joins a game with waiting player or creates a new one. Returns the state of the game."
  param :name, String, required: true, desc: "The name of the player."
  error code: Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request], desc: "when the name is missing"
  description <<eos
This method will join the first waiting game or create a new game if there isn't anyone waiting. It returns the
game id and player id.
  {
    game_id: 1,
    player_id: 3
  }
eos
  def create
    if params[:name].nil?
      render json: { error: "Name of the player is missing" }, status: :bad_request
    else
      game = Game.create_or_find_waiting_game!
      player = game.players.create!(name: params[:name])
      render json: { game_id: game.id, player_id: player.id }
    end
  end
end
