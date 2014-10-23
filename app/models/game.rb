class Game < ActiveRecord::Base
  has_many :players, dependent: :destroy
  has_many :turns, dependent: :destroy

  NUMBER_OF_PLAYERS = 2

  def state
    if players.size < NUMBER_OF_PLAYERS
      :waiting
    elsif players.all?(&:dead?)
      :draw
    elsif winner.present?
      :finished
    elsif current_turn.present? && current_turn.timed_out?
      :timed_out
    else
      :running
    end
  end

  def winner
    players.reject(&:dead?).first if players.select(&:dead?).size == NUMBER_OF_PLAYERS - 1
  end

  def current_turn
    turns.last
  end
end
