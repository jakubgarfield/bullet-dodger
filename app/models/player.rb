class Player < ActiveRecord::Base
  belongs_to :game
  has_many :player_turns, dependent: :destroy
  has_many :moves, through: :player_turns

  validates :game, presence: true
  validates :name, presence: true

  BOUNDARY = 2

  def dead?
    return false unless opponent.present?

    position = 0
    opponent_position = 0
    moves.zip(opponent.moves).each do |steps|
      step = steps[0]
      opponent_step = steps[1]

      return false unless step.present? && opponent_step.present?

      position = clamp_to_boundary(position + step.to_i)
      opponent_position = clamp_to_boundary(opponent_position - opponent_step.to_i)

      return opponent_step.shot? if step.shot? && position == opponent_position
      return true if opponent_step.shot? && position == opponent_position
    end
    false
  end

  def opponent
    game.players.where.not(id: id).first
  end

  private
  def clamp_to_boundary(position)
    [-BOUNDARY, position, BOUNDARY].sort[1]
  end
end
