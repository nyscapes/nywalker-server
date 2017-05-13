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

    it "responds with an access token" do
      post apiurl + "/token", {}, { "HTTP_ACCEPT" => "application/vnd.api+json" }
      expect(JSON.parse(last_response.body)["access_token"]).to eq "secret!"
    end
  end

  context "when logging out" do
    it "sends the data to /revoke" do
      post apiurl + "/revoke", {}, { "HTTP_ACCEPT" => "application/vnd.api+json" }
      expect(last_response.status).to eq 200
    end
  end
end
