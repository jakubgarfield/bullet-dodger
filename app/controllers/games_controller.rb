class GamesController < ApplicationController
  def show
    game = Game.find(params[:id])
    render json: GameJsonPresenter.new(game).to_json
  end

  def create
    if params[:name].present?
      render json: { error: "Name of the player is missing" }, status: :bad_request
    else
      game = Game.create_or_find_waiting_game!
      game.players.create!(name: params[:name])
      render json: GameJsonPresenter.new(game).to_json
    end
  end
end
