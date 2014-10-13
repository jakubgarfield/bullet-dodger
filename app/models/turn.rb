class Turn < ActiveRecord::Base
  belongs_to :game
  has_many :player_turns, dependent: :destroy

  def opponents_moves(player)
  end

  def state
    # waiting / finished / timed-out
  end
end
