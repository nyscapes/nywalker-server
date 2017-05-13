require 'spec_helper'

describe "NYWalker API" do
  let(:apiurl) { "/api/v1" }

  it "punts if the request doesn't ask for JSON API" do
    get apiurl 
    expect(last_response.status).to eq 406
  end

  it "accepts a request that asks for JSON API" do
    get apiurl, {}, { "HTTP_ACCEPT" => "application/vnd.api+json" }
    expect(last_response.status).to eq 200
  end

  context "when logging in" do
    it "sends the data to /token" do
      post apiurl + "/token", {}, { "HTTP_ACCEPT" => "application/vnd.api+json" }
      expect(last_response.status).to eq 200
    end
  end
end
