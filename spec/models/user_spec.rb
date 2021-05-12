require "rails_helper"

RSpec.describe User, type: :model do
  describe "db table" do
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:role).of_type(:integer) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:role) }
  end

  describe "validate enum attribute" do
    it { is_expected.to define_enum_for(:role).with_values({ journalist: 1 }) }
  end

  describe "Relationships between article and user" do
    it { is_expected.to have_many(:articles) }
  end

  describe "Factory" do
    it "should have valid Factory" do
      expect(create(:user)).to be_valid
    end
  end
end
