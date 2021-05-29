RSpec.describe Article, type: :model do
  describe 'db table' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:teaser).of_type(:text) }
    it { is_expected.to have_db_column(:body).of_type(:text) }
    it { is_expected.to have_db_column(:category).of_type(:string) }
    it { is_expected.to have_db_column(:location).of_type(:string) }
    it { is_expected.to have_db_column(:theme).of_type(:string) }
    it { is_expected.to have_db_column(:backyard).of_type(:boolean) }
    it { is_expected.to have_db_column(:premium).of_type(:boolean) }
    it { is_expected.to have_db_column(:published).of_type(:boolean) }
    it { is_expected.to have_db_column(:language).of_type(:string) }
  end

  describe 'status' do
    it { is_expected.to define_enum_for(:status).with_values({arcived: 1, draft: 5, published: 10}) }
  end

  describe 'Validation' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_inclusion_of(:backyard).in_array([false, true]) }

    context 'Normal article' do
      before { allow(subject).to receive(:is_backyard?).and_return(false) }

      it { is_expected.to validate_presence_of :teaser }
      it { is_expected.to validate_presence_of :category }
      it { is_expected.to validate_presence_of :language }
      it { is_expected.to validate_inclusion_of(:premium).in_array([false, true]) }
      it {
        is_expected.to validate_inclusion_of(:category)
          .in_array(%w[Science Aliens Covid Illuminati Politics Hollywood])
      }
      it { is_expected.to validate_inclusion_of(:published).in_array([false, true])}
    end

    context 'Backyard article' do
      before { allow(subject).to receive(:is_backyard?).and_return(true) }
      it { is_expected.to validate_presence_of :theme }
      it { is_expected.to validate_presence_of :location }
    end
  end

  describe '#image' do
    subject { create(:article).image }

    it {
      is_expected.to be_an_instance_of ActiveStorage::Attached::One
    }
  end

  describe 'Relationships' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments) }
  end

  describe 'Relationship between article and ratings' do
    before { allow(subject).to receive(:is_backyard?).and_return(false) }
    it { is_expected.to have_many(:ratings) }
  end

  describe 'Factory' do
    it 'is expected to have valid Factory' do
      expect(create(:article)).to be_valid
    end
  end
end
