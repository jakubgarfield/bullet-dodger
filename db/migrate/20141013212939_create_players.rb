class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.belongs_to :game, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
