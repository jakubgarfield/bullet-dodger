class GamesController < ApplicationController
  def show
    @game = Game.find_by_id(params[:id])

    if @game.nil?
      head :not_found
    else
      render json: GameJsonPresenter.new(@game).to_json
    end
  end

  def create
    return if params[:game][:username].nil?


    ### accepts
    # username
    #
    ### returns
    # game { id, opponent { id, name } }
  end
end
