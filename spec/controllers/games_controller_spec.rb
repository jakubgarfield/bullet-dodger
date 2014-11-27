require 'rails_helper'

RSpec.describe GamesController, :type => :controller do
  def json
    @json ||= JSON.parse(response.body)
  end

  describe "#show" do
    let(:game) { double() }
    let(:game_presenter) { instance_spy(GamePresenter) }
    let(:game_hash) { { test: "value"} }

    before do
      expect(Game).to receive(:find).with("1").and_return(game)
      expect(GamePresenter).to receive(:new).with(game).and_return(game_presenter)
      expect(game_presenter).to receive(:to_h).and_return(game_hash)
    end

    it "returns 200" do
      get :show, id: 1
      expect(response).to be_success
    end

    it "returns json" do
      get :show, id: 1
      expect(json["test"]).to eq "value"
    end
  end

  describe "#create" do
    context "when player name is missing" do
      it "returns 400" do
        post :create
        expect(response).to be_bad_request
        expect(json["error"]).to eq "Missing parameter name"
      end
    end

    context "when name is present" do
      let(:game) { Game.new(id: 321) }
      let(:player) { Player.new(id: 123, name: "Jed") }

      before do
        expect(Game).to receive(:create_or_find_waiting_game!).and_return(game)
        expect(game).to receive_message_chain(:players, :create!).with({ name: player.name }).and_return(player)
      end

      it "creates returns a game and player" do
        post :create, name: player.name
        expect(response).to be_success
        expect(json["game_id"]).to eq game.id
        expect(json["player_id"]).to eq player.id
      end
    end
  end
end
