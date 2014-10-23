class Turn < ActiveRecord::Base
  belongs_to :game
  has_many :player_turns, dependent: :destroy

  validates :game, presence: true

  def timed_out?
    !completed? && player_turns.any? { |turn| turn.created_at + 30.seconds < DateTime.now }
  end

  def completed?
    player_turns.size == Game::NUMBER_OF_PLAYERS
  end
end
