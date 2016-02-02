require 'rails_helper'

RSpec.describe Api::V1::VictoriesController do
  describe '#index' do
    let!(:victories) { create_list :victory, 5 }

    subject { get :index }

    it 'returns a 200 response status' do
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

      it_behaves_like 'not found'
    end

    context 'factory exists'
    let!(:victory) { create :victory }

    subject { get :show, id: victory.id }

    it 'returns a 200 response status' do
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

  describe '#create' do
    let!(:user) { create :user }

    context 'with invalid params' do
      before :each do
        sign_in user
        auth_headers = user.create_new_auth_token
        request.headers.merge!(auth_headers)
      end

      subject { xhr :post, :create, victory: { user_id: user.id } }

      it 'returns a 422 response status' do
        expect(subject.status).to eq 422
      end

      it 'returns errors' do
        expect(subject.body).to eq({
          errors: [
            { body: [ 'can\'t be blank' ] }
          ]
        }.to_json)
      end
    end

    context 'with valid params' do
      context 'for the same user' do
        before :each do
          sign_in user
          auth_headers = user.create_new_auth_token
          request.headers.merge!(auth_headers)
        end

        subject { xhr :post, :create, victory: { user_id: user.id, body: 'Lorem ipsum.' } }

        it 'returns a 200 response status' do
          expect(subject.status).to eq 200
        end

        it 'creates a new victory' do
          expect { subject }.to change(Victory, :count).by(1)
        end
      end

      context 'for another user' do
        let!(:another_user) { create :user }

        subject { xhr :post, :create, victory: { user_id: another_user.id, body: 'Lorem ipsum.' } }

        it_behaves_like 'not found'
      end
    end
  end
end
