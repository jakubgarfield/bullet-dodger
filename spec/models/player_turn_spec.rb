require 'rails_helper'

RSpec.describe PlayerTurn, :type => :model do
  let(:player_turn) { PlayerTurn.new }
  describe "on validations for" do
    subject do
      player_turn.valid?
      player_turn.errors
    end

    describe "#player" do
      context "when missing" do
        it { should have_key(:player) }
      end
    end

    describe "#turn" do
      context "when missing" do
        it { should have_key(:turn) }
      end
    end
  end
end
