require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    subject(:user) { create :user }

    it { is_expected.to validate_presence_of :nickname }
    it { is_expected.to validate_uniqueness_of :nickname }
  end

  describe 'associations' do
    it { is_expected.to have_many(:victories).dependent(:destroy) }
    it { is_expected.to have_many(:votes).dependent(:destroy) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:nickname).of_type(:string).with_options(null: false) }
  end
end