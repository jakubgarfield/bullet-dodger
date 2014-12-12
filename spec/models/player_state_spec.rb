require 'rails_helper'

RSpec.describe PlayerState, :type => :model do
  let(:shoot) { Move.new(action: "shoot") }
  let(:reload) { Move.new(action: "reload") }
  let(:player_state) { PlayerState.new }

  describe "#shoots?" do
    subject { player_state.shoots? }

    context " when player has enough ammo" do
      before { player_state.act(shoot) }
      it { should eq true }
    end

    context "when player doesn't have enough ammo" do
      let(:player_state) { PlayerState.new(ammo: 0) }
      before { player_state.act(shoot) }
      it { should eq false }
    end

    context "when player doesn't shoot" do
      before { player_state.act(reload) }
      it { should eq false }
    end

    context "when doesn't have ammo, reloads and shoot again" do
      let(:player_state) { PlayerState.new(ammo: 0) }
      before do
        player_state.act(reload)
        player_state.act(shoot)
      end
      it { should eq true }
    end
  end

  describe "dead?" do
    let(:opponent) { PlayerState.new }
    subject { player_state.dead? }

    context "when opponent hits" do
      before do
        opponent.act(shoot)
        player_state.react(opponent)
      end
      it { should eq true }
    end

    context "when opponent shoots from different position" do
      let(:opponent) { PlayerState.new(position: 1) }
      before do
        opponent.act(shoot)
        player_state.react(opponent)
      end
      it { should eq false }
    end

    context "when opponent tries to shoot without ammo" do
      let(:opponent) { PlayerState.new(ammo: 0) }
      before do
        opponent.act(shoot)
        player_state.react(opponent)
      end
      it { should eq false }
    end

    context "when opponent doesn't shoot" do
      before do
        opponent.act(reload)
        player_state.react(opponent)
      end
      it { should eq false }
    end
  end
end
