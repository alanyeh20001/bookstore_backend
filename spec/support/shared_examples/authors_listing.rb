RSpec.shared_examples "authors listing" do
  describe "GET /api/v1/authors" do
    let!(:author) { create_list(:author, 2) }

    before { get "/api/v1/authors" }

    it { expect(response).to be_success }

    it "returns all authors" do
      expect(json_response.length).to eq(2)
    end
  end

  describe "GET /api/v1/authors/:id" do
    let(:author) { create(:author) }

    before { get "/api/v1/authors/#{author.id}" }

    it { expect(response).to be_success }

    it "returns specific author" do
      expect(json_response[:id]).to eq(author.id)
    end
  end
end
