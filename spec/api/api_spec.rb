require "shared/contexts"

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

  context "when posting" do
    context "with no payload, it" do
      it "fails" do
        post apiurl + "/", {}, accept
        expect(last_response.status).to eq 400
      end

      it "returns an error of 'no_request_payload'" do
        post apiurl + "/", {}, accept
        expect(JSON.parse(last_response.body)["error"]).to eq "no_request_payload"
      end
    end
  end

end

