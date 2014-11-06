class PlayerTurnsController < ApplicationController
  def create
    player = Player.find(params[:player_id])
    turn = Turn.find(params[:turn_id])

    if turn.player_turns.where(player: player).exists?
      render json: { error: "Moves were submitted already" }, status: :not_acceptible
    elsif params[:moves].nil? || params[:moves].size != PlayerTurn::NUMBER_OF_MOVES
      render json: { error: "You must submit #{PlayerTurn::NUMBER_OF_MOVES} moves."}, status: :bad_request
    else
      player_turn = turn.player_turn.build(player: player)
      params[:moves].each { |move| player_turn.moves.build(action: move) }

      if player_turn.save
        head :created
      else
        render json: { error: player_turn.errors.full_messages.to_sentence }, status: :bad_request
      end
    end
  end
end
