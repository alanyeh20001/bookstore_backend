require "rails_helper"

RSpec.describe AuthenticateUserCommand do
  before { Timecop.freeze(Time.new(2017,7,18)) }
  after  { Timecop.return }

  let(:email)    { "test@gmail.com" }
  let(:password) { "11111111" }
  let!(:user)    { create(:user, email: email, password: password) }
  let(:expected_token) { "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1MDAzOTM2MDB9.O_cbmz01zIehFRZhOnX2a9DciOOxddkcFYVqPNLsO58" }

  subject { described_class.call(email, password) }

  it { expect(subject.result).to eq(expected_token) }
end
