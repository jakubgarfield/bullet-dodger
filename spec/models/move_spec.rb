require 'rails_helper'

RSpec.describe Move, :type => :model do
  let(:move) { Move.new }
  describe "on validations for" do
    subject do
      move.valid?
      move.errors
    end

    describe "#player_turn" do
      context "when missing" do
        it { should have_key(:player_turn) }
      end
    end

    describe "#action" do
      context "when missing" do
        it { should have_key(:action) }
      end
    end
  end

  describe "#to_i" do
    subject { move.to_i }

    context "when left" do
      before { move.action = Move::LEFT }
      it { should eq -1 }
    end

    context "when right" do
      before { move.action = Move::RIGHT }
      it { should eq 1 }
    end

    context "when wait" do
      before { move.action = Move::WAIT }
      it { should eq 0 }
    end

    context "when shoot" do
      before { move.action = Move::SHOOT }
      it { should eq 0 }
    end
  end

  describe "#shot?" do
    subject { move.shot? }

    context "when shooting" do
      before { move.action = Move::SHOOT }
      it { should eq true }
    end

    context "when doing something else" do
      before { move.action = Move::WAIT }
      it { should eq false }
    end
  end
end
