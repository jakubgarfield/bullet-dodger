class CreateTurns < ActiveRecord::Migration
  def change
    create_table :turns do |t|
      t.belongs_to :game, null: false

      t.timestamps
    end
  end
end
