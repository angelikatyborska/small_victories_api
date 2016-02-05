require 'rails_helper'

RSpec.describe Victory do
  describe 'validations' do
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :user }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:votes).dependent(:destroy) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:body).of_type(:text).with_options(null: false) }
  end
end