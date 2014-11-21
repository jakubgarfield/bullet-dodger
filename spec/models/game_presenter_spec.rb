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
      let(:expected_hash) do
        {
          id: game.id,
          state: :running,
          current_turn: { id: game.turns.order(:created_at).last.id },
          winner: nil,
          players: [{ id: jakub.id, name: jakub.name }, { id: jed.id, name: jed.name }]
        }
      end
      it { should eq expected_hash }
    end

    context "when game is just created" do
      let(:game) { Game.new }
      let(:expected_hash) do
        {
          id: nil,
          state: :waiting_for_players,
          current_turn: nil,
          winner: nil,
          players: []
        }
      end
      it { should eq expected_hash }
    end

    context "when there is only one player" do
      let(:game) { games(:waiting_game) }
      let(:luke) { players(:luke) }
      let(:expected_hash) do
        {
          id: game.id,
          state: :waiting_for_players,
          current_turn: nil,
          winner: nil,
          players: [ { id: luke.id, name: luke.name }]
        }
      end
      it { should eq expected_hash }
    end

    context "when timed out" do
      let(:game) { games(:timed_out_game) }
      let(:diego) { players(:diego) }
      let(:hao) { players(:hao) }
      let(:expected_hash) do
        {
          id: game.id,
          state: :timed_out,
          current_turn: { id: game.turns.order(:created_at).last.id },
          winner: nil,
          players: [{ id: diego.id, name: diego.name}, { id: hao.id, name: hao.name }]
        }
      end
      it { should eq expected_hash }
    end

    context "when there is a winner" do
      let(:game) { games(:finished_game) }
      let(:steven) { players(:steven) }
      let(:leandro) { players(:leandro) }
      let(:expected_hash) do
        {
          id: game.id,
          state: :finished,
          current_turn: { id: game.turns.order(:created_at).last.id },
          winner: { id: leandro.id, name: leandro.name },
          players: [{ id: steven.id, name: steven.name}, { id: leandro.id, name: leandro.name }]
        }
      end
      it { should eq expected_hash }
    end

    context "when players shoot each other" do
      let(:game) { games(:draw_game) }
      let(:ben) { players(:ben) }
      let(:nick) { players(:nick) }
      let(:expected_hash) do
        {
          id: game.id,
          state: :finished,
          current_turn: { id: game.turns.order(:created_at).last.id },
          winner: nil,
          players: [{ id: ben.id, name: ben.name}, { id: nick.id, name: nick.name }]
        }
      end
      it { should eq expected_hash }
    end
  end
end
