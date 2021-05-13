RSpec.describe User, type: :model do
  describe 'db table' do
    it { is_expected.to have_db_column(:role).of_type(:integer) }
  end

  describe 'role' do
    it { is_expected.to define_enum_for(:role).with_values({ member: 1, journalist: 5 }) }
  end

  describe 'Relationship between article and user' do
    it { is_expected.to have_many(:articles) }
  end

  describe 'factory' do
    it 'is expected to have a default factory' do
      expect(create(:user)).to be_valid
    end
  end
end
