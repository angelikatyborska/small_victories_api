RSpec.describe Api::V1::UsersController do
  describe '#show' do
    context 'user doesn\'t exist' do
      subject { get :show, id: 0 }

      it { expect(subject.status).to eq 404 }
      it { expect(subject.body).to eq 'Not found'.to_json }
    end

    context 'user exists' do
      let!(:user) { create :user }

      subject { get :show, id: user.id }

      it { expect(subject.status).to eq 200 }
      it { expect(subject.body).to eq({
        user: {
          id: user.id,
          email: user.email,
          nickname: user.nickname
        }
      }.to_json) }
    end
  end
end