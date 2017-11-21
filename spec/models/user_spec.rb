require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:email) }
  it "validates the uniqueness of email" do
    user = create(:user)
    expect(User.new).to validate_uniqueness_of(:email)
  end

  describe "has_secure_password" do
    let(:user) { build(:user, password: nil) }

    it "should not be valid without password" do
      expect(user.save).to be_falsy
    end

    it "should be valid with proper password" do
      user.password = "11111111"
      expect(user.save).to be_truthy
    end
  end
end
