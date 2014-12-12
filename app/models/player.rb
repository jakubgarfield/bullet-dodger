class Player < ActiveRecord::Base
  belongs_to :game
  has_many :player_turns, dependent: :destroy
  has_many :moves, through: :player_turns

  validates :game, presence: true
  validates :name, presence: true

  def dead?
    return false unless opponent.present?

    state, opponents_state = PlayerState.new, PlayerState.new

    moves.zip(opponent.moves).each do |(move, opponents_move)|
      return false if move.nil? || opponents_move.nil?

      state.act(move)
      opponents_state.act(opponents_move)

      state.react(opponents_state)
      opponents_state.react(state)

      return true if state.dead?
      return false if opponents_state.dead?
    end

    false
  end

  def opponent
    game.players.where.not(id: id).first
  end
end
