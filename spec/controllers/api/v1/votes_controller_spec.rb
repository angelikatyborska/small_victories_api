require 'rails_helper'

RSpec.describe Api::V1::VotesController do
  describe 'GET #index' do
    let!(:victory) { create :victory }
    let!(:other_victory) { create :victory }
    let!(:votes) { create_list :vote, 5, victory: victory }
    let!(:other_votes) { create_list :vote, 5, victory: other_victory }

    context 'victory doesn\'t exist' do
      subject { xhr :get, :index, victory_id: 0 }

      it { is_expected.to respond_with_status 404 }
    end

    context 'victory exists' do
      subject { xhr :get, :index, victory_id: victory.id }

      it '', :show_in_doc do is_expected.to respond_with_status 200 end
      it { is_expected.to respond_with_records votes.map(&:id) }
      it { is_expected.to respond_with_keys [:id, :value, { user: [:id, :nickname] }] }
    end
  end

  describe 'POST #create' do
    let!(:victory) { create :victory }
    let!(:user) { create :user }

    before :each do
      authorize_request(user)
    end

    context 'victory doesn\'t exist' do
      subject { xhr :post, :create, victory_id: 0, vote: { user_id: user.id, value: 1 } }

      it { is_expected.to respond_with_status 404 }
    end

    context 'victory exists' do
      context 'for the same user' do
        context 'with valid params' do
          subject { xhr :post, :create, victory_id: victory.id, vote: { user_id: user.id, value: 1 } }

          it { is_expected.to respond_with_status 200 }

          it 'creates a new vote', :show_in_doc do
            expect { subject }.to change(Vote, :count).by(1)
          end
        end
      end

      context 'with invalid params' do
        before { Apipie.configuration.validate = false }

        subject { xhr :post, :create, victory_id: victory.id, vote: { user_id: user.id, value: 0 } }

        it { is_expected.to respond_with_status 422 }
        it { is_expected.to respond_with_errors [{ value: ['is not included in the list'] }] }
      end

      context 'for another user' do
        let!(:another_user) { create :user }

        subject { xhr :post, :create, victory_id: victory.id, vote: { user_id: another_user.id, value: 1 } }

        it { is_expected.to respond_with_status 403 }
      end
    end
  end

  describe 'PUT #update' do
    let!(:user) { create :user }
    let!(:vote) { create :vote, value: 1, user: user }

    before :each do
      authorize_request(user)
    end

    context 'victory doesn\'t exist' do
      subject { xhr :put, :update, victory_id: 0, id: 0, vote: {} }

      it { is_expected.to respond_with_status 404 }
    end

    context 'victory exists' do
      context 'vote doesn\'t exist' do
        subject { xhr :put, :update, victory_id: vote.victory.id, id: 0, vote: {} }

        it { is_expected.to respond_with_status 404 }
      end

      context 'vote exists' do
        context 'for the same user' do
          context 'with valid params' do
            let!(:other_user) { create :user }
            subject { xhr :put, :update, victory_id: vote.victory.id, id: vote.id, vote: {
              value: -1, user_id: other_user.id
            } }

            it { is_expected.to respond_with_status 200 }

            it 'changes vote\'s value, but not user', :show_in_doc do
              subject
              expect(vote.reload.value).to eq -1
              expect(vote.reload.user_id).to eq user.id
            end
          end

          context 'with invalid params' do
            before { Apipie.configuration.validate = false }

            subject { xhr :put, :update, victory_id: vote.victory.id, id: vote.id, vote: { value: 0 } }

            it { is_expected.to respond_with_status 422 }

            it 'does not change vote\'s value' do
              subject
              expect(vote.reload.value).to eq 1
            end
          end
        end

        context 'for another user' do
          let!(:another_vote) { create :vote }

          subject { xhr :put, :update, victory_id: another_vote.victory.id, id: another_vote.id, vote: { value: -1 } }

          it { is_expected.to respond_with_status 403 }
        end
      end
    end
  end


  describe 'DELETE #destroy' do
    let!(:user) { create :user }
    let!(:another_user) { create :user }
    let!(:vote) { create :vote, user: user }
    let!(:another_vote) { create :vote, user: another_user }

    before :each do
      authorize_request(user)
    end

    context 'victory doesn\'t exist' do
      subject { xhr :delete, :destroy, victory_id: 0, id: 0 }

      it { is_expected.to respond_with_status 404 }
    end

    context 'victory exists' do
      context 'vote doesn\'t exist' do
        subject { xhr :delete, :destroy, victory_id: vote.victory.id, id: 0 }

        it { is_expected.to respond_with_status 404 }
      end

      context 'vote exists' do
        context 'for the same user' do
          subject { xhr :delete, :destroy, victory_id: vote.victory.id, id: vote }

          it { is_expected.to respond_with_status 204 }

          it 'deletes the vote', :show_in_doc do
            expect { subject }.to change(Vote, :count).by(-1)
          end
        end

        context 'for another user' do
          subject { xhr :delete, :destroy, victory_id: another_vote.victory.id, id: another_vote }

          it { is_expected.to respond_with_status 403 }
        end
      end
    end
  end
end