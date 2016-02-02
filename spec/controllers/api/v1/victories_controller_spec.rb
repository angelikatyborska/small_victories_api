require 'rails_helper'

RSpec.describe Api::V1::VictoriesController do
  describe '#index' do
    let!(:victories) { create_list :victory, 5 }

    subject { get :index }

    it 'returns a successful 200 response' do
      expect(subject.status).to eq 200
    end

    it 'returns all victories' do
      parsed_response = JSON.parse(subject.body)
      expect(parsed_response['victories'].length).to eq victories.length
    end
  end

  describe '#show' do
    context 'victory doesn\'t exist' do
      subject { get :show, id: 0 }

      it 'returns a 404 response' do
        expect(subject.status).to eq 404
      end

      it 'returns not found' do
        expect(subject.body).to eq({ errors: ['Not found.'] }.to_json)
      end
    end

    context 'factory exists'
    let!(:victory) { create :victory }

    subject { get :show, id: victory.id }

    it 'returns a successful 200 response' do
      expect(subject.status).to eq 200
    end

    it 'returns the victory' do
      expect(subject.body).to eq({
        victory: {
          id: victory.id,
          user_id: victory.user.id,
          body: victory.body
        }
      }.to_json)
    end
  end
end
