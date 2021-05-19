RSpec.describe Rating, type: :model do
  describe 'db table' do
    it { is_expected.to have_db_column(:rating).of_type(:integer) }
    it { is_expected.to have_db_column(:article_id).of_type(:integer) }
  end

  describe 'Relationship between rating and article' do
    it { is_expected.to belong_to(:article) }
  end
end
