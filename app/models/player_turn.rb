class PlayerTurn < ActiveRecord::Base
  belongs_to :player
  belongs_to :turn

  has_many :moves, dependent: :destroy
end
