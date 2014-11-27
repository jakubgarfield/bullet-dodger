require 'rails_helper'

RSpec.describe Player, :type => :model do
  fixtures :games
  fixtures :players
  fixtures :turns
  fixtures :player_turns
  fixtures :moves

  let(:player) { Player.new }
  describe "on validations for" do
    subject do
      player.valid?
      player.errors
    end

    describe "#game" do
      context "when missing" do
        it { should have_key(:game) }
      end
    end
  end

  describe "#opponent" do
    subject { player.opponent }

    context "when there is none" do
      let(:player) { players(:luke) }
      it { should eq nil }
    end

    context "when Jed asks for an opponent" do
      let(:player) { players(:jed) }
      it "should be Jakub" do
        expect(subject.name).to eq "Jakub"
      end
    end
  end

  describe "#dead?" do
    subject { player.dead? }

    context "when there wasn't any lethal shot" do
      let(:player) { players(:jed) }
      it { should be false}
    end

    context "when player is shot" do
      let(:player) { players(:steven) }
      it { should be true }
    end

    context "when there isn't an opponent" do
      let(:player) { players(:luke) }
      it { should be false }
    end
  end
end
