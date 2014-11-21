class TurnsController < ApplicationController
  resource_description do
    description "It is used to get the state of the turn."
  end

  api :GET, "/games/:game_id/turns/:id", "Gets the status of a turn."
  description <<-eos
This method is meant for polling after you submitted your moves and you are waiting for an opponent to do the thing.

It returns
  {
    state: waiting,
    moves:
    {
      { player_id: 2, moves: ["left", "left", "shoot", "right", "wait"] }
    }
  }

The possible states are
* waiting,
* timed_out and
* completed.

When completed, the moves should contain the moves from both players and you should check the state of the game
and possibly move to the next turn if the game hasn't finished.
eos
  def show
    turn = Turn.find(params[:id])
    render json: TurnPresenter.new(turn).to_h
  end
end
