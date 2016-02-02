RSpec.describe Api::V1::UsersController do
  describe '#index' do
    let!(:users) { create_list :user, 3 }

    subject { get :index }

    it 'returns a successful 200 response' do
      expect(subject.status).to eq 200
    end

    it 'returns all users' do
      parsed_response = JSON.parse(subject.body)
      expect(parsed_response['users'].length).to eq users.length
    end
  end

  describe '#show' do
    context 'user doesn\'t exist' do
      subject { get :show, id: 0 }

      it 'returns a 404 response' do
        expect(subject.status).to eq 404
      end

      it 'returns not found' do
        expect(subject.body).to eq({ errors: ['Not found.'] }.to_json)
      end
    end

    context 'user exists' do
      let!(:user) { create :user }

      subject { get :show, id: user.id }

      it 'returns a successful 200 response' do
        expect(subject.status).to eq 200
      end

      it 'returns the user' do
        expect(subject.body).to eq({
          user: {
            id: user.id,
            email: user.email,
            nickname: user.nickname
          }
        }.to_json)
      end
    end
  end
end