class GameJsonPresenter
  def initialize(game)
    @game = game
  end

  def to_json
    {
      id: @game.id,
      state: game_state,
      current_turn: ({ id: @game.current_turn.id } if @game.current_turn.present?),
      winner: ({ id: @game.winner.id } if @game.winner?),
      players: players_to_hash
    }
  end

  private
  def game_state
    if @game.waiting_for_players?
      :waiting_for_players
    elsif @game.timed_out?
      :timed_out
    elsif @game.winner? || @game.draw?
      :finished
    else
      :running
    end
  end

  def players_to_hash
    @game.players.map do |player|
      { id: player.id, name: player.name }
    end
  end
end
