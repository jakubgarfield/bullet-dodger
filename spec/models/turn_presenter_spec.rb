require 'rails_helper'

RSpec.describe GamePresenter, :type => :model do
  fixtures :games
  fixtures :players
  fixtures :turns
  fixtures :player_turns
  fixtures :moves

  describe "#to_h" do
    subject { TurnPresenter.new(turn).to_h }

    context "when turn is complete" do
      let(:turn) { turns(:running_1) }
      let(:jakub) { players(:jakub) }
      let(:jed) { players(:jed) }

      it "is completed and has the turns information" do
        expect(subject[:state]).to eq :completed
        expect(subject[:moves]).to include({ player_id: jakub.id, moves: ["wait", "shoot"] })
        expect(subject[:moves]).to include({ player_id: jed.id, moves: ["left", "left"] })
      end
    end

    context "when turn timed out" do
      let(:turn) { turns(:running_2) }
      let(:jakub) { players(:jakub) }
      let(:expected_hash) do
        {
          state: :waiting,
          moves: [{ player_id: jakub.id, moves: ["shoot", "shoot"] }]
        }
      end
      it { should eq expected_hash }
    end

    context "when turn is incomplete" do
      let(:turn) { turns(:timed_out_1) }
      let(:diego) { players(:diego) }
      let(:expected_hash) do
        {
          state: :timed_out,
          moves: [{ player_id: diego.id, moves: [] }]
        }
      end
      it { should eq expected_hash }
    end
  end
end
