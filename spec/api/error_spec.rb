# frozen_string_literal: true
require "shared/contexts"

describe "NYWalker API" do
  include_context "api"

  context "returns errors with JSON" do
    # see http://jsonapi.org/examples/#error-objects
    it "that provide a string status number"
    it "that provide a source with a pointer attribute"
    it "that provide a title"
    it "that provide a detail"
  end

end
