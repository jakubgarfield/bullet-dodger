class GamePresenter
  def initialize(game)
    @game = game
  end

  def to_h
    {
      id: @game.id,
      state: game_state,
      current_turn: ({ id: @game.current_turn.id } if @game.current_turn.present?),
      winner: (player_to_h(@game.winner) if @game.winner?),
      players: players_to_h
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

  def players_to_h
    @game.players.map { |player| player_to_h(player) }
  end

  def player_to_h(player)
    { id: player.id, name: player.name }
  end
end
