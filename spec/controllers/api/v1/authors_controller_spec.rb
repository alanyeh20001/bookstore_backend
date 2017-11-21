require "rails_helper"

RSpec.describe Api::V1::AuthorsController, type: :request do
  context "when non-admin user" do
    login_user

    it_behaves_like "authors listing"

    describe "POST /api/v1/authors" do
      let(:attrs) { attributes_for(:author) }

      it "returns forbidden http status" do
        post_author_creation_endpoint(attrs)
        expect(response.status).to eq(403)
      end

      it "cannot create an author" do
        expect { post_author_creation_endpoint(attrs) }.to change(Author, :count).by(0)
      end

      it "returns error messages" do
        post_author_creation_endpoint(attrs)
        expect(json_response[:error]).to be_present
        expect(json_response[:error]).to eq("Not Permitted")
      end
    end

    describe "PUT /api/v1/authors/:id" do
      it_behaves_like "not authorized for author modification"
    end

    describe "DELETE /api/v1/authors/:id" do
      it_behaves_like "not authorized for author modification"
    end
  end

  context "when admin user" do
    login_user("admin")

    it_behaves_like "authors listing"

    describe "POST /api/v1/authors" do
      let(:attrs) { attributes_for(:author) }

      context "when successfully created" do
        it "returns created http status" do
          post_author_creation_endpoint(attrs)
          expect(response.status).to eq(201)
        end

        it "creates an author" do
          expect { post_author_creation_endpoint(attrs) }.to change(Author, :count).by(1)
        end
      end

      context "when failed to create" do
        before { post "/api/v1/authors", params: { author: { name: nil } } }

        it "returns unprocessable_entity http status" do
          expect(response.status).to eq(422)
        end

        it "fails with error messages" do
          expect(json_response[:errors]).to be_present
          expect(json_response[:errors][:name][0]).to eq("can't be blank")
        end
      end
    end

    describe "PUT /api/v1/authors/:id" do
      let(:author) { create(:author) }
      let(:name)   { Faker::Name.name }

      context "when successfully update" do
        before {
          put "/api/v1/authors/#{author.id}", params: { author: { name: name } }
        }

        it "returns ok http status" do
          expect(response.status).to eq(200)
        end

        it "should update name" do
          expect(json_response[:name]).to eq(name)
        end
      end

      context "when failed to update" do
        before {
          put "/api/v1/authors/#{author.id}", params: { author: { name: nil } }
        }

        it "returns unprocessable_entity http status" do
          expect(response.status).to eq(422)
        end

        it "fails with error messages" do
          expect(json_response[:errors]).to be_present
          expect(json_response[:errors][:name][0]).to eq("can't be blank")
        end
      end
    end

    describe "DELETE /api/v1/authors/:id" do
      let(:author) { create(:author) }

      before { delete "/api/v1/authors/#{author.id}" }

      it "returns ok http status" do
        expect(response.status).to eq(204)
      end
    end
  end

  def post_author_creation_endpoint(attrs)
    post "/api/v1/authors", params: { author: attrs }
  end
end
