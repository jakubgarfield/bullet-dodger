class TurnsController < ApplicationController
  def show
    turn = Turn.find(params[:id])
    render json: TurnJsonPresenter.new(turn).to_json
  end
end
