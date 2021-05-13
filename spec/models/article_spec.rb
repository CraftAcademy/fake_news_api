require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'db table' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:teaser).of_type(:text) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
  end

  describe 'Validation' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :teaser }
    it { is_expected.to validate_presence_of :body }
  end

  describe 'Factory' do
    it 'is expected to have valid Factory' do
      expect(create(:article)).to be_valid
    end
  end
end