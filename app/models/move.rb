class Move < ActiveRecord::Base
  LEFT = "left"
  RIGHT = "right"
  SHOOT = "shoot"
  RELOAD = "reload"
  VALID_MOVES = [LEFT, RIGHT, SHOOT, RELOAD]

  belongs_to :player_turn

  validates :player_turn, presence: true
  validates :action, presence: true, inclusion: { in: VALID_MOVES }

  def to_i
    case action
    when LEFT
      -1
    when RIGHT
      1
    else
      0
    end
  end

  def shot?
    action == SHOOT
  end

  def reload?
    action == RELOAD
  end
end
