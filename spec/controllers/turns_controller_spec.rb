require 'rails_helper'

RSpec.describe TurnsController, :type => :controller do
  def json
    @json ||= JSON.parse(response.body)
  end

  describe "#show" do
    let(:turn) { double() }
    let(:turn_hash) { { test: "value"} }

    before do
      expect(Turn).to receive(:find).with("1").and_return(turn)
      expect(TurnPresenter).to receive_message_chain(:new, :to_h).and_return(turn_hash)
    end

    it "returns 200" do
      get :show, game_id: 2, id: 1
      expect(response).to be_success
    end

    it "returns json" do
      get :show, game_id: 2, id: 1
      expect(json["test"]).to eq "value"
    end
  end
end
