require 'rails_helper'

RSpec.describe Api::V1::VictoriesController do
  describe 'GET #index' do
    let!(:victories) { create_list :victory, 5 }

    subject { xhr :get, :index }

    it 'returns a 200 response status' do
      expect(subject.status).to eq 200
    end

    it 'returns all victories' do
      expect(JSON.parse(subject.body)['victories'].length).to eq victories.length
    end
  end

  describe 'GET #show' do
    context 'victory doesn\'t exist' do
      subject { xhr :get, :show, id: 0 }

      it 'returns a 404 response status' do
        expect(subject.status).to eq 404
      end
    end

    context 'factory exists'
    let!(:victory) { create :victory }

    subject { xhr :get, :show, id: victory.id }

    it 'returns a 200 response status' do
      expect(subject.status).to eq 200
    end

    it 'returns the victory' do
      expect(subject.body).to eq({
        victory: {
          id: victory.id,
          body: victory.body,
          created_at: victory.created_at.utc.iso8601,
          user: {
            id: victory.user.id,
            nickname: victory.user.nickname
          }
        }
      }.to_json)
    end
  end

  describe 'POST #create' do
    let!(:user) { create :user }

    before :each do
      authorize_request(user)
    end

    context 'for the same user' do
      context 'with valid params' do
        subject { xhr :post, :create, victory: { user_id: user.id, body: 'Lorem ipsum.' } }

        it 'returns a 200 response status' do
          expect(subject.status).to eq 200
        end

        it 'creates a new victory' do
          expect { subject }.to change(Victory, :count).by(1)
        end
      end

      context 'with invalid params' do
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

      context 'for another user' do
        let!(:another_user) { create :user }

        subject { xhr :post, :create, victory: { user_id: another_user.id, body: 'Lorem ipsum.' } }

        it 'returns a 403 response status' do
          expect(subject.status).to eq 403
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create :user }

    before :each do
      authorize_request(user)
    end

    context 'victory doesn\'t exist' do
      subject { xhr :delete, :destroy, id: 0 }

      it 'returns a 404 response status' do
        expect(subject.status).to eq 404
      end
    end

    context 'victory exists' do
      context 'for the same user' do
        let!(:victory) { create :victory, user: user }

        subject { xhr :delete, :destroy, id: victory.id }

        it 'returns a 204 response status' do
          expect(subject.status).to eq 204
        end

        it 'deletes the victory' do
          expect { subject }.to change(Victory, :count).by(-1)
        end
      end

      context 'for another user' do
        let!(:another_user) { create :user }
        let!(:victory) { create :victory, user: another_user }

        subject { xhr :delete, :destroy, id: victory.id }

        it 'returns a 403 response status' do
          expect(subject.status).to eq 403
        end
      end
    end
  end
end
