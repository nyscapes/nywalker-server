# frozen_string_literal: true
require "shared/contexts"
require "shared/routes"

describe "NYWalker API - /books" do
  context "in general" do
    it_should_behave_like "a route", "books"
  end

  describe "GET /books/:book_id/instances" do
    it "should return a list of instances, sorted."
    it "should 404 if the book does not exist."
  end

end
