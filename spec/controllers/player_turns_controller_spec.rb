require 'rails_helper'

RSpec.describe PlayerTurnsController, :type => :controller do
  fixtures :games
  fixtures :players
  fixtures :turns
  fixtures :player_turns
  fixtures :moves

  def json
    @json ||= JSON.parse(response.body)
  end

  describe "#create" do
    context "when moves are missing" do
      it "returns 400" do
        post :create, game_id: 123, turn_id: 321, player_id: 3
        expect(response).to be_bad_request
        expect(json["error"]).to eq "Missing parameter moves"
      end
    end

    context "when player id is missing" do
      it "returns 400" do
        post :create, game_id: 123, turn_id: 321, moves: []
        expect(response).to be_bad_request
        expect(json["error"]).to eq "Missing parameter player_id"
      end
    end

    context "when there is not enough moves" do
      let(:player) { instance_spy(Player) }
      let(:turn) { instance_spy(Turn) }

      before do
        expect(Player).to receive(:find).with("3").and_return(player)
        expect(Turn).to receive(:find).with("321").and_return(turn)
        expect(turn).to receive_message_chain(:player_turns, :where, :exists?).and_return(false)
      end

      it "returns 400" do
        post :create, game_id: 123, turn_id: 321, player_id: 3, moves: []
        expect(response).to be_bad_request
        expect(json["error"]).to eq "You must submit #{PlayerTurn::NUMBER_OF_MOVES} moves."
      end
    end

    context "when player submitted moves already" do
      let(:player) { instance_spy(Player) }
      let(:turn) { instance_spy(Turn) }

      before do
        expect(Player).to receive(:find).with("3").and_return(player)
        expect(Turn).to receive(:find).with("321").and_return(turn)
        expect(turn).to receive_message_chain(:player_turns, :where, :exists?).and_return(true)
      end

      it "returns 406" do
        post :create, game_id: 123, turn_id: 321, player_id: 3, moves: []
        expect(response.code).to eq "406"
        expect(json["error"]).to eq "Moves were submitted already"
      end
    end

    context "when one of the moves is invalid" do
      let(:game) { games(:running_game) }
      let(:player) { players(:jed) }
      let(:turn) { turns(:running_2) }

      it "returns 400" do
        post :create, game_id: game.id, turn_id: turn.id, player_id: player.id, moves: ["wrong", "right", "right", "shoot", "left"]
        expect(response).to be_bad_request
        expect(json["error"]).to eq "Moves is invalid"
      end
    end

    context "when everything is alright" do
      let(:game) { games(:running_game) }
      let(:player) { players(:jed) }
      let(:turn) { turns(:running_2) }

      def post_turn
        post :create, game_id: game.id, turn_id: turn.id, player_id: player.id,
          moves: ["left", "right", "right", "shoot", "left"]
      end

      it "creates returns a game and player" do
        expect { post_turn }.to change { PlayerTurn.count }.by(1)
        expect(response.code).to eq "201"
      end
    end
  end
end
