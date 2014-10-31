class GamesController < ApplicationController
  def show
    ### returns
    # state of the game
    # current turn { id }
    # winner { id, name }
  end

  def create
    ### accepts
    # username
    #
    ### returns
    # game { id, opponent { id, name } }
  end
end
