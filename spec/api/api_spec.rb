require_relative "./shared.rb"

describe "NYWalker API" do
  include_context "api"

  it "punts if the request doesn't ask for JSON API" do
    get apiurl 
    expect(last_response.status).to eq 406
  end

  it "accepts a request that asks for JSON API" do
    get apiurl + "/", {}, accept
    expect(last_response.status).to eq 200
  end

end

