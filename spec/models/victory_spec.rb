require 'rails_helper'

RSpec.describe Victory do
  describe 'validations' do
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :rating }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:votes).dependent(:destroy) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:body).of_type(:text).with_options(null: false) }
    it { is_expected.to have_db_column(:rating).of_type(:integer).with_options(null: false, default: 0) }
  end

  describe '#rating' do
    let!(:victory) { create :victory }

    subject { victory.rating }

    context 'with no votes' do
      it { is_expected.to eq 0 }
    end

    context 'with votes' do
      let!(:positive_votes) { create_list :vote, 5, victory: victory, value: 1 }
      let!(:negative_votes) { create_list :vote, 8, victory: victory, value: -1 }

      it { is_expected.to eq -3 }
    end
  end
end