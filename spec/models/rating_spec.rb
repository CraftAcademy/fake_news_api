RSpec.describe Rating, type: :model do
  describe 'db table' do
    it { is_expected.to have_db_column(:rating).of_type(:integer) }
    it { is_expected.to have_db_column(:article_id).of_type(:integer) }
  end

  describe 'Validation' do
    it { is_expected.to validate_presence_of :rating }
    it { is_expected.to validate_presence_of :article_id }
    it {
      is_expected.to validate_inclusion_of(:rating)
        .in_array([1..5])
    }
  end

  describe 'Relationship between rating and article' do
    it { is_expected.to belong_to(:article) }
  end
end
