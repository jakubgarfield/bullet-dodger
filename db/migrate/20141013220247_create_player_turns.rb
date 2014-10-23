class CreatePlayerTurns < ActiveRecord::Migration
  def change
    create_table :player_turns do |t|
      t.belongs_to :player, null: false
      t.belongs_to :turn, null: false

      t.timestamps
    end
  end
end
