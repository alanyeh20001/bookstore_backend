RSpec.shared_examples "not authorized for author modification" do
  let(:author) { create(:author) }

  before { put "/api/v1/authors/#{author.id}" }

  it "returns forbidden http status" do
    expect(response.status).to eq(403)
  end

  it "returns error messages" do
    expect(json_response[:error]).to be_present
    expect(json_response[:error]).to eq("Not Permitted")
  end
end
