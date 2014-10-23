require 'rails_helper'

RSpec.describe Turn, :type => :model do
  fixtures :turns
  fixtures :player_turns

  let(:turn) { Turn.new }

  describe "on validations for" do
    subject do
      turn.valid?
      turn.errors
    end

    describe "#game" do
      context "when missing" do
        it { should have_key(:game) }
      end
    end
  end

  describe "#completed?" do
    subject { turn.completed? }

    context "when no player submitted a turn" do
      it { should eq false }
    end

    context "when one player submitted a turn" do
      let(:turn) { turns(:running_2) }
      it { should eq false }
    end

    context "when both players submitted a turn" do
      let(:turn) { turns(:running_1) }
      it { should eq true }
    end
  end

  describe "#timed_out?" do
    subject { turn.timed_out? }

    context "when no player submitted a turn" do
      it { should eq false }
    end

    context "when one player submitted a turn more than 30 seconds ago" do
      let(:turn) { turns(:timed_out_1) }
      it { should eq true }
    end

    context "when one player submitted a turn" do
      let(:turn) { turns(:running_2) }
      it { should eq false }
    end

    context "when both playes submitted a turn" do
      let(:turn) { turns(:running_1) }
      it { should eq false }
    end
  end
end
