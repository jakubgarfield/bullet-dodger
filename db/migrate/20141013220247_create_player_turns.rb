class CreatePlayerTurns < ActiveRecord::Migration
  def change
    create_table :player_turns do |t|

      t.timestamps
    end
  end
end
