require 'spec_helper'

describe "NYWalker API" do
  let(:apiurl) { "/api/v1" }

  it "should punt if the request doesn't ask for JSON API" do
    get apiurl 
    expect(last_response.status).to eq 406
  end

  it "should accept a request that asks for JSON API" do
    get apiurl, {}, { "HTTP_ACCEPT" => "application/vnd.api+json" }
    expect(last_response.status).to eq 200
  end
end
