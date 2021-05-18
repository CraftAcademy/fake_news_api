RSpec.describe Article, type: :model do
  describe 'db table' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:teaser).of_type(:text) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
    it { is_expected.to have_db_column(:category).of_type(:string) }
  end

  describe 'Validation' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :teaser }
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :category }
    it {
      is_expected.to validate_inclusion_of(:category)
        .in_array(%w[Science Aliens Covid Illuminati Politics Hollywood])
    }
  end

  describe '#image' do
    subject { create(:article).image }

    it {
      is_expected.to be_an_instance_of ActiveStorage::Attached::One
    }
  end

  describe 'Relationship between article and user' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'Factory' do
    it 'is expected to have valid Factory' do
      expect(create(:article)).to be_valid
    end
  end
end
