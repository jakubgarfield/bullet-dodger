class Player < ActiveRecord::Base
  has_many :player_turns, dependent: :destroy
  belongs_to :game

  # name
end
