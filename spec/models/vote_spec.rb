require 'rails_helper'

RSpec.describe Vote do
  describe 'validations' do
    it { is_expected.to validate_presence_of :value }
    it { is_expected.to validate_inclusion_of(:value).in_array [-1, 1] }
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :victory }

    it 'allows only one vote per victory per user' do
      user = create :user
      victory = create :victory
      vote = create :vote, user: user, victory: victory

      expect(build(:vote, user: user, victory: victory)).to be_invalid
    end
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:value).of_type(:integer) }
    it { is_expected.to have_db_column :user_id }
    it { is_expected.to have_db_column :victory_id }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :victory }
  end

  describe '#destroy' do
    let!(:victory) { create :victory }
    let!(:vote) { create :vote, victory: victory, value: -1 }

    it 'updates victory rating' do
      expect(victory.reload.rating).to eq -1
      vote.destroy
      expect(victory.reload.rating).to eq 0
    end
  end

  describe '#save' do
    let!(:victory) { create :victory }
    let!(:vote) { create :vote, victory: victory, value: -1 }

    it 'updates victory rating' do
      expect(victory.reload.rating).to eq -1
      vote.value = 1
      vote.save
      expect(victory.reload.rating).to eq 1
    end
  end
end