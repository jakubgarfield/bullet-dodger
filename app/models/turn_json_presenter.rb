class TurnJsonPresenter
  def initialize(turn)
    @turn = turn
  end

  def to_json
    {
      state: turn_state,
      moves: moves_to_hash
    }
  end

  private
  def turn_state
    if @turn.timed_out?
      :timed_out
    elsif @turn.completed?
      :completed
    else
      :waiting
    end
  end

  def moves_to_hash
    @turn.player_turns.map do |player_turn|
      {
        player_id: player_turn.player.id,
        moves: player_turn.moves.map { |move| move.action }
      }
    end
  end
end
