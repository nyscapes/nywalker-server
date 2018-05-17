require "shared/contexts"
require "shared/routes"

describe "NYWalker API - /books" do
  context "in general" do
    it_should_behave_like "a route", "books"
  end

end
