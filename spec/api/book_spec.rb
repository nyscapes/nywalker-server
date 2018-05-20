# frozen_string_literal: true
require "shared/contexts"
require "shared/routes"

describe "NYWalker API - /books" do
  include_context "api"

  context "in general" do
    it_should_behave_like "a route", "books"
  end

  describe "GET /books/:book_id/instances" do
    let(:book){ create :book }
    let(:second_book){ create :second_book }

    before(:each) do
      create :instance, page: 2, book: book 
      create_list :instance, 4, book: book 
      create_list :instance, 5, book: second_book 
    end

    it "should give a 200" do
      getjsonapi "/books/#{book.id}/instances"
      expect(last_response.status).to eq 200
    end

    it "should return a list of only the instances for the book" do
      getjsonapi "/books/#{book.id}/instances"
      expect(JSON.parse(last_response.body)["data"].length).to be 5
    end

    it "should return a list of all instances, sorted." do
      getjsonapi "/books/#{book.id}/instances"
      instances = JSON.parse(last_response.body, symbolize_names: true)[:data]
      expect(instances.first[:attributes][:page]).to be < instances.last[:attributes][:page]
    end

    it "should 404 if the book does not exist." do
      getjsonapi "/books/1/instances"
      expect(last_response.status).to eq 404
    end
  end

end
