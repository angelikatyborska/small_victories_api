require 'rails_helper'

RSpec.describe Api::V1::VictoriesController do
  describe 'GET #index' do
    context 'without params' do
      let!(:victories) { create_list :victory, Kaminari.config.default_per_page * 3 }

      subject { xhr :get, :index }

      it { is_expected.to respond_with_status 200 }

      it 'returns the total count of victories in the header' do
        expect(subject.header['X-Total-Count']).to eq (Kaminari.config.default_per_page * 3).to_s
      end

      it 'returns the first page of latest victories', :show_in_doc do
        is_expected.to respond_with_records(
          Victory
            .order(described_class::DEFAULT_SORT_PARAMS)
            .limit(Kaminari.config.default_per_page)
            .map(&:id)
        )
      end

      it { is_expected.to respond_with_keys [:id, :created_at, :user, :body, :rating] }

      it 'includes pagination links in the header' do
        expect(subject.header['Link']).to match /rel=\"next\"/
        expect(subject.header['Link']).to match /rel=\"last\"/
      end
    end

    describe 'pagination' do
      let!(:victories) { create_list :victory, 15 }

      subject { xhr :get, :index, page: 2, per_page: 5 }

      it 'returns the second page of latest victories', :show_in_doc do
        parsed_response = JSON.parse(subject.body)

        expect(parsed_response.length).to eq 5
        is_expected.to respond_with_records(
          Victory
            .order(described_class::DEFAULT_SORT_PARAMS)
            .limit(5)
            .offset(5)
            .map(&:id)
        )
      end

      it 'includes pagination links in the header' do
        expect(subject.header['Link']).to match /rel=\"prev\"/
        expect(subject.header['Link']).to match /rel=\"first\"/
      end
    end

    describe 'sorting' do
      let!(:victories) do
        ('A'..'Z').each_with_object([]) do |char, victories|
          3.times do
            victories << create(:victory, body: char * 10)
          end
        end
      end

      context 'valid sort param' do
        subject { xhr :get, :index, sort: '-body,+created_at' }

        it 'returns the first page of sorted victories', :show_in_doc do
          parsed_response = JSON.parse(subject.body)

          expect(parsed_response.length).to eq Kaminari.config.default_per_page
          is_expected.to respond_with_records(
            Victory
              .order(body: :desc, created_at: :asc)
              .limit(Kaminari.config.default_per_page)
              .map(&:id)
          )
        end
      end

      context 'invalid sort param' do
        before { Apipie.configuration.validate = false }

        context 'without order' do
          subject { xhr :get, :index, sort: 'body' }

          it 'returns the first page of victories sorted with default order' do
            parsed_response = JSON.parse(subject.body)

            expect(parsed_response.length).to eq Kaminari.config.default_per_page
            is_expected.to respond_with_records(
              Victory
                .order(described_class::DEFAULT_SORT_PARAMS)
                .limit(Kaminari.config.default_per_page)
                .map(&:id)
            )
          end
        end

        context 'invalid attribute' do
          subject { xhr :get, :index, sort: '+invalid_attribute' }

          it 'returns the first page of victories sorted with default order' do
            parsed_response = JSON.parse(subject.body)

            expect(parsed_response.length).to eq Kaminari.config.default_per_page
            is_expected.to respond_with_records(
              Victory
                .order(described_class::DEFAULT_SORT_PARAMS)
                .limit(Kaminari.config.default_per_page)
                .map(&:id)
            )
          end
        end
      end
    end

    describe 'finding by user' do
      let!(:victories) { create_list :victory, 15 }

      context 'user exists' do
        subject { xhr :get, :index, user: victories[0].user.nickname }

        it 'only finds victories submitted by the user', :show_in_doc do
          is_expected.to respond_with_records [victories[0].id]
        end
      end

      context 'user doesn\'t exist' do
        subject { xhr :get, :index, user: 'invalid_nickname' }

        it 'finds nothing' do
          is_expected.to respond_with_records []
        end
      end
    end
  end

  describe 'GET #show' do
    context 'victory doesn\'t exist' do
      subject { xhr :get, :show, id: 0 }

      it { is_expected.to respond_with_status 404 }
    end

    context 'factory exists'
    let!(:victory) { create :victory }

    subject { xhr :get, :show, id: victory.id }

    it { is_expected.to respond_with_status 200 }

    it 'returns the victory', :show_in_doc do
      parsed_response = JSON.parse(subject.body)

      expect(parsed_response['id']).to eq victory.id
      expect(parsed_response['created_at']).to eq victory.created_at.utc.iso8601
      expect(parsed_response['rating']).to eq 0
      expect(parsed_response['body']).to eq victory.body
      expect(parsed_response['user']).to eq({
        'id' => victory.user.id,
        'nickname' => victory.user.nickname
      })
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

        it { is_expected.to respond_with_status 200 }

        it 'creates a new victory', :show_in_doc do
          expect { subject }.to change(Victory, :count).by(1)
        end
      end

      context 'with invalid params' do
        before { Apipie.configuration.validate = false }

        subject { xhr :post, :create, victory: { user_id: user.id } }

        it { is_expected.to respond_with_status 422 }
        it { is_expected.to respond_with_errors [{ body: ['can\'t be blank'] }] }
      end

      context 'for another user' do
        let!(:another_user) { create :user }

        subject { xhr :post, :create, victory: { user_id: another_user.id, body: 'Lorem ipsum.' } }

        it { is_expected.to respond_with_status 403 }
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

      it { is_expected.to respond_with_status 404 }
    end

    context 'victory exists' do
      context 'for the same user' do
        let!(:victory) { create :victory, user: user }

        subject { xhr :delete, :destroy, id: victory.id }

        it { is_expected.to respond_with_status 204 }

        it 'deletes the victory', :show_in_doc do
          expect { subject }.to change(Victory, :count).by(-1)
        end
      end

      context 'for another user' do
        let!(:another_user) { create :user }
        let!(:victory) { create :victory, user: another_user }

        subject { xhr :delete, :destroy, id: victory.id }

        it { is_expected.to respond_with_status 403 }
      end
    end
  end
end
