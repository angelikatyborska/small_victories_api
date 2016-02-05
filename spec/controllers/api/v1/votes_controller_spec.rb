require 'rails_helper'

RSpec.describe Api::V1::VotesController do
  describe '#index' do
    let!(:victory) { create :victory }
    let!(:other_victory) { create :victory }
    let!(:votes) { create_list :vote, 5, victory: victory }
    let!(:other_votes) { create_list :vote, 5, victory: other_victory }

    subject { xhr :get, :index, victory_id: victory.id }

    it 'returns a 200 response status' do
      expect(subject.status).to eq 200
    end

    it 'returns the votes for the victory' do
      expect(JSON.parse(subject.body).map { |vote| vote['id'] }).to match_array votes.map(&:id)
    end

    it 'includes only the right keys' do
      expect(JSON.parse(subject.body)[0].keys).to match_array ['id', 'value', 'user']
      expect(JSON.parse(subject.body)[0]['user'].keys).to match_array ['id', 'nickname']
    end
  end
end