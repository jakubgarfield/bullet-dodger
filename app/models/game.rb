class Game < ActiveRecord::Base
  has_many :players, dependent: :destroy

  def state
    # waiting / running / finished
  end

  def current_turn
  end
end
