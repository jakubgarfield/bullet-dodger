class PlayerTurnsController < ApplicationController
  resource_description do
    description "This resource is used to submit moves for a round."
  end

  api :POST, "/games/:id/turns/:id/player_turns", "Player can submit his moves for one turn, but just once for each turn."
  param :moves, Array, required: true, desc: "An array with exactly #{PlayerTurn::NUMBER_OF_MOVES} moves that are represented by their names. The available moves are #{ Move::VALID_MOVES.join(", ")}."
  error code: Rack::Utils::SYMBOL_TO_STATUS_CODE[:not_acceptable], desc: "when moves were already submitted"
  error code: Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request], desc: "when moves are invalid. See error message for an explanation."
  description <<-eos
If the method is called properly it returns 201 HTTP code.
eos
  def create
    player = Player.find(params[:player_id])
    turn = Turn.find(params[:turn_id])

    if turn.player_turns.where(player: player).exists?
      render json: { error: "Moves were submitted already" }, status: :not_acceptable
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
