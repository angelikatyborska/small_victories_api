require 'rails_helper'

RSpec.describe Api::V1::VotesController do
  describe 'GET #index' do
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

  describe 'POST #create' do
    let!(:victory) { create :victory }
    let!(:user) { create :user }

    before :each do
      authorize_request(user)
    end

    context 'for the same user' do
      context 'with valid params' do
        subject { xhr :post, :create, victory_id: victory.id, vote: { user_id: user.id, value: 1 } }

        it 'returns a 200 response status' do
          expect(subject.status).to eq 200
        end

        it 'creates a new vote' do
          expect { subject }.to change(Vote, :count).by(1)
        end
      end
    end

    context 'with invalid params' do
      subject { xhr :post, :create, victory_id: victory.id, vote: { user_id: user.id, value: 0 } }

      it 'returns a 422 response status' do
        expect(subject.status).to eq 422
      end

      it 'returns errors' do
        expect(subject.body).to eq({
          errors: [
            { value: [ 'is not included in the list' ] }
          ]
        }.to_json)
      end
    end

    context 'for another user' do
      let!(:another_user) { create :user }

      subject { xhr :post, :create, victory_id: victory.id, vote: { user_id: another_user.id, value: 1 } }

      it 'returns a 403 response status' do
        expect(subject.status).to eq 403
      end
    end
  end
end