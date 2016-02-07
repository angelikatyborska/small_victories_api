RSpec.describe Api::V1::UsersController do
  describe '#index' do
    let!(:users) { create_list :user, 3 }

    subject { xhr :get, :index }

    it 'returns all users', :show_in_doc do
      expect(JSON.parse(subject.body).length).to eq users.length
    end

    it { is_expected.to respond_with_status 200 }
    it { is_expected.to respond_with_keys [:id, :nickname] }
  end

  describe '#show' do
    context 'user doesn\'t exist' do
      subject { xhr :get, :show, nickname: 'does_not_exist' }

      it { is_expected.to respond_with_status 404 }
    end

    context 'user exists' do
      let!(:user) { create :user }
      let!(:victory) { create :victory, user: user }
      let!(:vote) { create :vote, user: user }

      subject { xhr :get, :show, nickname: user.nickname }

      it { is_expected.to respond_with_status 200 }
      it { is_expected.to respond_with_keys [:id, :nickname, :email, :victories, :votes] }

      it 'returns the user with correct data', :show_in_doc do
        parsed_response = JSON.parse(subject.body)

        expect(parsed_response['id']).to eq user.id
        expect(parsed_response['nickname']).to eq user.nickname
        expect(parsed_response['email']).to eq user.email
        expect(parsed_response['victories'][0].keys).to match_array ['body', 'id', 'created_at']
        expect(parsed_response['votes'][0].keys).to match_array ['id', 'value', 'victory_id']
      end
    end
  end
end