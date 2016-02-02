RSpec.describe Api::V1::UsersController do
  describe '#index' do
    let!(:users) { create_list :user, 3 }

    subject { get :index }

    it 'returns a 200 response status' do
      expect(subject.status).to eq 200
    end

    it 'returns all users' do
      expect(JSON.parse(subject.body)['users'].length).to eq users.length
    end
  end

  describe '#show' do
    context 'user doesn\'t exist' do
      subject { get :show, id: 0 }

      it_behaves_like 'not found'
    end

    context 'user exists' do
      let!(:user) { create :user }

      subject { get :show, id: user.id }

      it 'returns a 200 response status' do
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