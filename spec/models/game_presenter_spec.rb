require 'rails_helper'

RSpec.describe GamePresenter, :type => :model do
  fixtures :games
  fixtures :players
  fixtures :turns
  fixtures :player_turns
  fixtures :moves

  describe "#to_h" do
    subject { GamePresenter.new(game).to_h }

    context "when game is running" do
      let(:game) { games(:running_game) }
      let(:jakub) { players(:jakub) }
      let(:jed) { players(:jed) }

      it "is running with all the information" do
        expect(subject[:id]).to eq game.id
        expect(subject[:state]).to eq :running
        expect(subject[:current_turn]).to include(id: game.turns.order(:created_at).last.id)
        expect(subject[:winner]).to be_nil
        expect(subject[:players]).to include({ id: jakub.id, name: jakub.name })
        expect(subject[:players]).to include({ id: jed.id, name: jed.name })
      end
    end

    context "when game is just created" do
      let(:game) { Game.new }

      it "is waiting for players" do
        expect(subject[:state]).to eq :waiting_for_players
        expect(subject[:current_turn]).to be_nil
        expect(subject[:winner]).to be_nil
        expect(subject[:players]).to be_empty
      end
    end

    context "when there is only one player" do
      let(:game) { games(:waiting_game) }
      let(:luke) { players(:luke) }

      it "is is waiting for players with one player in" do
        expect(subject[:id]).to eq game.id
        expect(subject[:state]).to eq :waiting_for_players
        expect(subject[:current_turn]).to be_nil
        expect(subject[:winner]).to be_nil
        expect(subject[:players]).to include({ id: luke.id, name: luke.name })
      end
    end

    context "when timed out" do
      let(:game) { games(:timed_out_game) }
      let(:diego) { players(:diego) }
      let(:hao) { players(:hao) }

      it "is timed out" do
        expect(subject[:id]).to eq game.id
        expect(subject[:state]).to eq :timed_out
        expect(subject[:current_turn]).to include(id: game.turns.order(:created_at).last.id)
        expect(subject[:winner]).to be_nil
        expect(subject[:players]).to include({ id: diego.id, name: diego.name })
        expect(subject[:players]).to include({ id: hao.id, name: hao.name })
      end
    end

    context "when there is a winner" do
      let(:game) { games(:finished_game) }
      let(:steven) { players(:steven) }
      let(:leandro) { players(:leandro) }

      it "is finished" do
        expect(subject[:id]).to eq game.id
        expect(subject[:state]).to eq :finished
        expect(subject[:current_turn]).to include(id: game.turns.order(:created_at).last.id)
        expect(subject[:winner]).to include(id: leandro.id)
        expect(subject[:players]).to include({ id: steven.id, name: steven.name })
        expect(subject[:players]).to include({ id: leandro.id, name: leandro.name })
      end
    end

    context "when players shoot each other" do
      let(:game) { games(:draw_game) }
      let(:ben) { players(:ben) }
      let(:nick) { players(:nick) }

      it "is finished with no winner" do
        expect(subject[:id]).to eq game.id
        expect(subject[:state]).to eq :finished
        expect(subject[:current_turn]).to include(id: game.turns.order(:created_at).last.id)
        expect(subject[:winner]).to be_nil
        expect(subject[:players]).to include({ id: ben.id, name: ben.name })
        expect(subject[:players]).to include({ id: nick.id, name: nick.name })
      end
    end
  end
end
