class Move < ActiveRecord::Base
  belongs_to :player_turn

  validates :player_turn, presence: true
  validates :action, presence: true

  LEFT = "left"
  RIGHT = "right"
  WAIT = "wait"
  SHOOT = "shoot"


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
end
