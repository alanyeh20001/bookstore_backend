require "rails_helper"

RSpec.describe Api::V1::BooksController, type: :request do
  describe "GET /api/v1/authors/:author_id/books" do
    context "when non-admin user" do
      login_user

      let(:author) { create(:author_with_books) }

      before { get "/api/v1/authors/#{author.id}/books" }

      it { expect(response.status).to eq(200) }

      it "returns all books belong to author" do
        expect(json_response.length).to eq(2)
      end
    end

    context "when admin user" do
      login_user(is_admin: true)

      let(:author) { create(:author_with_books) }

      before { get "/api/v1/authors/#{author.id}/books" }

      it { expect(response.status).to eq(200) }

      it "returns all books belong to author" do
        expect(json_response.length).to eq(2)
      end
    end
  end

  describe "GET /api/v1/authors/:author_id/books/:id" do
    context "when non-admin user" do
      login_user

      let(:author) { create(:author) }
      let(:book)    { create(:book, author: author) }

      before { get "/api/v1/authors/#{author.id}/books/#{book.id}" }

      it { expect(response.status).to eq(200) }

      it "returns specific book belongs to author" do
        expect(json_response[:id]).to eq(book.id)
      end
    end

    context "when admin user" do
      login_user(is_admin: true)

      let(:author) { create(:author) }
      let(:book)    { create(:book, author: author) }

      before { get "/api/v1/authors/#{author.id}/books/#{book.id}" }

      it { expect(response.status).to eq(200) }

      it "returns specific book belongs to author" do
        expect(json_response[:id]).to eq(book.id)
      end
    end

    describe "POST /api/v1/authors/:author_id/books" do
      let(:author)      { create(:author) }
      let(:book_attrs)  { attributes_for(:book) }

      context "when non-admin user" do
        login_user

        it "returns forbidden http status" do
          post "/api/v1/authors/#{author.id}/books", params: { book: book_attrs }
          expect(response.status).to eq(403)
        end

        it "cannot create book" do
          expect { post "/api/v1/authors/#{author.id}/books", params: { book: book_attrs } }.to change(Book, :count).by(0)
        end

        it "returns error message" do
          post "/api/v1/authors/#{author.id}/books", params: { book: book_attrs }
          expect(json_response[:error]).to be_present
          expect(json_response[:error]).to eq('Not Permitted')
        end
      end

      context "when admin user" do
        login_user("admin")

        let(:author) { create(:author) }
        let(:book_attrs) { attributes_for(:book) }

        context "when successfully created" do
          it "returns created http status" do
            post "/api/v1/authors/#{author.id}/books", params: { book: book_attrs }
            expect(response.status).to eq(201)
          end

          it "creates a book" do
            expect { post "/api/v1/authors/#{author.id}/books", params: { book: book_attrs } }.to change(Book, :count).by(1)
          end
        end

        context "when failed to create" do
          it "returns unprocessable_entity http status" do
            post "/api/v1/authors/#{author.id}/books", params: { book: book_attrs.merge(title: nil) }
            expect(response.status).to eq(422)
          end

          it "fails with error messages" do
            post "/api/v1/authors/#{author.id}/books", params: { book: book_attrs.merge(title: nil) }
            expect(json_response[:errors]).to be_present
          end
        end
      end
    end

    describe "PUT /api/v1/authors/:author_id/books/:id" do
      context "when non-admin user" do
        login_user

        let(:author) { create(:author) }
        let(:book)   { create(:book, author: author) }

        it "returns forbidden http status" do
          put "/api/v1/authors/#{author.id}/books/#{book.id}", params: { book: { title: "new_title" } }
          expect(response.status).to eq(403)
        end

        it "returns error messages" do
          put "/api/v1/authors/#{author.id}/books/#{book.id}", params: { book: { title: "new_title" } }
          expect(json_response[:error]).to be_present
        end
      end

      context "when admin user" do
        login_user("admin")

        let(:author) { create(:author) }
        let(:book)   { create(:book, author: author) }

        context "when successfully update" do
          it "returns ok http status" do
            put "/api/v1/authors/#{author.id}/books/#{book.id}", params: { book: { title: "new_title" } }
            expect(response.status).to eq(200)
          end

          it "should update name" do
            put "/api/v1/authors/#{author.id}/books/#{book.id}", params: { book: { title: "new_title" } }
            expect(Book.find(book.id).title).to eq("new_title")
          end
        end

        context "when failed to update" do
          before { allow_any_instance_of(Book).to receive(:update).and_return(false) }

          it "returns unprocessable_entity http status" do
            put "/api/v1/authors/#{author.id}/books/#{book.id}", params: { book: { title: "new_title" } }
            expect(response.status).to eq(422)
          end

          it "returns error messages" do
            put "/api/v1/authors/#{author.id}/books/#{book.id}", params: { book: { title: "new_title" } }
            expect(json_response[:errors]).to_not be_nil
          end
        end
      end
    end

    describe "DELETE /api/v1/authors/:author_id/books/:id" do
      context "when non-admin user" do
        login_user

        let(:author) { create(:author) }
        let(:book)   { create(:book, author: author) }

        it "returns forbidden http status" do
          delete "/api/v1/authors/#{author.id}/books/#{book.id}"
          expect(response.status).to eq(403)
        end

        it "returns error messages" do
          delete "/api/v1/authors/#{author.id}/books/#{book.id}"
          expect(json_response[:error]).to be_present
        end
      end

      context "when admin user" do
        login_user("admin")

        let(:author) { create(:author) }
        let(:book)   { create(:book, author: author) }

        it "returns ok http status" do
          delete "/api/v1/authors/#{author.id}"
          expect(response.status).to eq(204)
        end
      end
    end
  end
end
