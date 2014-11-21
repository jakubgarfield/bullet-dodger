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

  describe "#waiting_for_players" do
    subject { game.waiting_for_players? }

    context "when game is running" do
      let(:game) { games(:running_game) }
      it { should eq false }
    end

    context "when game is just created" do
      let(:game) { Game.new }
      it { should eq true }
    end

    context "when there is only one player" do
      let(:game) { games(:waiting_game) }
      it { should eq true }
    end

    context "when timed out" do
      let(:game) { games(:timed_out_game) }
      it { should eq false }
    end

    context "when there is a winner" do
      let(:game) { games(:finished_game) }
      it { should eq false }
    end

    context "when players shoot each other" do
      let(:game) { games(:draw_game) }
      it { should eq false }
    end
  end

  describe "#draw?" do
    subject { game.draw? }

    context "when game is running" do
      let(:game) { games(:running_game) }
      it { should eq false }
    end

    context "when game is just created" do
      let(:game) { Game.new }
      it { should eq false }
    end

    context "when there is only one player" do
      let(:game) { games(:waiting_game) }
      it { should eq false }
    end

    context "when timed out" do
      let(:game) { games(:timed_out_game) }
      it { should eq false }
    end

    context "when there is a winner" do
      let(:game) { games(:finished_game) }
      it { should eq false }
    end

    context "when players shoot each other" do
      let(:game) { games(:draw_game) }
      it { should eq true }
    end
  end

  describe "#winner?" do
    subject { game.winner? }

    context "when game is running" do
      let(:game) { games(:running_game) }
      it { should eq false }
    end

    context "when game is just created" do
      let(:game) { Game.new }
      it { should eq false }
    end

    context "when there is only one player" do
      let(:game) { games(:waiting_game) }
      it { should eq false }
    end

    context "when timed out" do
      let(:game) { games(:timed_out_game) }
      it { should eq false }
    end

    context "when there is a winner" do
      let(:game) { games(:finished_game) }
      it { should eq true }
    end

    context "when players shoot each other" do
      let(:game) { games(:draw_game) }
      it { should eq false }
    end
  end

  describe "#timed_out?" do
    subject { game.timed_out? }

    context "when game is running" do
      let(:game) { games(:running_game) }
      it { should eq false }
    end

    context "when game is just created" do
      let(:game) { Game.new }
      it { should eq false }
    end

    context "when there is only one player" do
      let(:game) { games(:waiting_game) }
      it { should eq false }
    end

    context "when timed out" do
      let(:game) { games(:timed_out_game) }
      it { should eq true }
    end

    context "when there is a winner" do
      let(:game) { games(:finished_game) }
      it { should eq false }
    end

    context "when players shoot each other" do
      let(:game) { games(:draw_game) }
      it { should eq false }
    end
  end

  describe "#waiting_for_turn_to_complete?" do
    subject { game.waiting_for_turn_to_complete? }

    context "when game is running" do
      let(:game) { games(:running_game) }
      it { should eq true }
    end

    context "when game is just created" do
      let(:game) { Game.new }
      it { should eq false }
    end

    context "when there is only one player" do
      let(:game) { games(:waiting_game) }
      it { should eq false }
    end

    context "when timed out" do
      let(:game) { games(:timed_out_game) }
      it { should eq false }
    end

    context "when there is a winner" do
      let(:game) { games(:finished_game) }
      it { should eq false }
    end

    context "when players shoot each other" do
      let(:game) { games(:draw_game) }
      it { should eq false }
    end
  end

  describe ".create_or_find_waiting_game!" do
    subject { Game.create_or_find_waiting_game! }

    context "when there is a waiting game" do
      it { should eq games(:waiting_game) }
    end

    context "when there is no waiting game" do
      let(:new_game) { double() }
      before do
        games(:waiting_game).delete
        expect(Game).to receive(:create!).and_return(new_game)
      end

      it { should eq new_game }
    end
  end

  describe "#winner" do
    subject { game.winner }

    context "when there is no winner" do
      let(:game) { games(:running_game) }
      it { should eq nil}
    end

    context "when there is a draw" do
      let(:game) { games(:draw_game) }
      it { should eq nil}
    end

    context "when there is a winner" do
      let(:game) { games(:finished_game) }
      it { should eq players(:leandro) }
    end
  end

  describe "#current_turn" do
    subject { game.current_turn }

    context "when game hasn't started yet" do
      let(:game) { games(:waiting_game) }
      it { should be nil }
    end

    context "when game has many turns" do
      let(:game) { games(:running_game) }
      let(:latest_turn) { games(:running_game).turns.order(:created_at).last }
      it { should eq latest_turn }
    end
  end
end
