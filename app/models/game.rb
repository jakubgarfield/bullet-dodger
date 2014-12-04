class Game < ActiveRecord::Base
  has_many :players, dependent: :destroy
  has_many :turns, dependent: :destroy

  NUMBER_OF_PLAYERS = 2

  def self.create_or_find_waiting_game!
    game_waiting_for_players || Game.create!
  end

  def waiting_for_players?
    players.size < NUMBER_OF_PLAYERS
  end

  def draw?
    !waiting_for_players? && players.all?(&:dead?)
  end

  def winner?
    winner.present?
  end

  def timed_out?
    last_turn.present? && last_turn.timed_out?
  end

  def waiting_for_turn_to_complete?
    last_turn.present? && !last_turn.completed? && !last_turn.timed_out?
  end

  def winner
    players.reject(&:dead?).first if players.select(&:dead?).size == NUMBER_OF_PLAYERS - 1
  end

  def current_turn
    if finished? || waiting_for_players?
      last_turn
    else
      get_or_create_turn!
    end
  end

  protected
  def self.game_waiting_for_players
    Game.joins("LEFT OUTER JOIN players ON players.game_id = games.id").group("games.id").having("COUNT(*) < 2").first
  end

  def get_or_create_turn!
    transaction do
      lock!
      if last_turn && !last_turn.completed?
        last_turn
      else
        turns.create!
      end
    end
  end

  def last_turn
    turns.order(:created_at).last
  end

  def finished?
    draw? || winner? || timed_out?
  end
end
