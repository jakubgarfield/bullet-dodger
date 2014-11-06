class PlayerTurn < ActiveRecord::Base
  NUMBER_OF_MOVES = 5

  belongs_to :player
  belongs_to :turn
  has_many :moves, dependent: :destroy

  validates :player, presence: true
  validates :turn, presence: true
end
