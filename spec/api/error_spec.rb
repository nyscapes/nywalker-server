require 'spec_helper'

describe "NYWalker API" do

  let(:apiurl) { "/api/v1" }
  let(:accept) { { "HTTP_ACCEPT" => "application/vnd.api+json" } }

  context "returns errors with JSON" do
    # see http://jsonapi.org/examples/#error-objects
    it "that provide a string status number"
    it "that provide a source with a pointer attribute"
    it "that provide a title"
    it "that provide a detail"
  end

end

