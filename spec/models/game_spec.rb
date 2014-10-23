require 'rails_helper'

RSpec.describe Game, :type => :model do
  fixtures :games
  fixtures :players
  fixtures :turns
  fixtures :player_turns
  fixtures :moves

  describe "::NUMBER_OF_PLAYERS" do
    it "is just for two playes" do
      expect(Game::NUMBER_OF_PLAYERS).to eq 2
    end
  end

  describe "#state" do
    subject { game.state }

    context "when game is running" do
      let(:game) { games(:running_game) }
      it { should eq :running }
    end

    context "when game is just created" do
      let(:game) { Game.new }
      it { should eq :waiting }
    end

    context "when there is only one player" do
      let(:game) { games(:waiting_game) }
      it { should eq :waiting }
    end

    context "when timed out" do
      let(:game) { games(:timed_out_game) }
      it { should eq :timed_out }
    end

    context "when there is a winner" do
      let(:game) { games(:finished_game) }
      it { should eq :finished }
    end

    context "when players shoot each other" do
      let(:game) { games(:draw_game) }
      it { should eq :draw }
    end
  end
end
