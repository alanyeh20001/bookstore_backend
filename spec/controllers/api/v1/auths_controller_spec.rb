require "rails_helper"

RSpec.describe Api::V1::AuthsController, type: :request do
  describe "POST /api/v1/auth" do
    let(:email)    { "test@gmail.com" }
    let(:password) { "11111111" }
    let!(:user) { create(:user, email: email, password: password) }

    context "when token command succeeds" do
      before { post "/api/v1/auth", params: { email: email, password: password } }

      it "returns ok http status" do
        expect(response.status).to eq(200)
      end

      it "retrieves token" do
        expect(json_response[:token]).to be_present
      end
    end

    context "when token command fails" do
      before { post "/api/v1/auth", params: { email: email, password: "111111" } }

      it "returns unauthorized http status" do
        expect(response.status).to eq(401)
      end

      it "retrieves error" do
        expect(json_response[:error]).to be_present
      end
    end
  end
end
