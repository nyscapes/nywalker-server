require_relative './shared.rb'

describe "NYWalker API - /books" do
  include_context "api"
  let(:book){ create :book }

  context "when the book is /books/:book_id" do
    it "returns the book with that id" do
      getjsonapi "/books/", book.id
      expect(delivery["data"]["attributes"]["name"]).to eq book.name
    end
  end

end
