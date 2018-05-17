require_relative './shared.rb'
require_relative './shared_examples.rb'

describe "NYWalker API - /books" do
  context "in general" do
    it_should_behave_like "a route", "books"
  end

end
