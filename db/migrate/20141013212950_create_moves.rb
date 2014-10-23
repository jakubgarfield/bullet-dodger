class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.belongs_to :player_turn, null: false
      t.string :action, null: false

      t.timestamps
    end
  end
end
