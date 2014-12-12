class PlayerState
  BOUNDARY = 2
  MAX_BULLET_COUNT = 6
  attr_reader :position

  def initialize(position: 0, ammo: MAX_BULLET_COUNT)
    @position = position
    @ammo = ammo
    @dead = false
    @can_shoot = @ammo > 0
  end

  def dead?
    @dead
  end

  def act(move)
    @current_move = move

    case @current_move.action
    when Move::RELOAD
      @ammo += 1 if @ammo < MAX_BULLET_COUNT
    when Move::SHOOT
      if @ammo > 0
        @can_shoot = true
        @ammo -= 1
      else
        @can_shoot = false
      end
    else
      @position = clamp_to_boundary(@position + @current_move.to_i)
    end
  end

  def react(opponent)
    @dead = opponent.shoots? && opponent.position == position
  end

  def shoots?
    @can_shoot && @current_move.shot?
  end

  private
  def clamp_to_boundary(position)
    [-BOUNDARY, position, BOUNDARY].sort[1]
  end
end

