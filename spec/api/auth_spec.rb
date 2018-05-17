require_relative "./shared.rb"

describe "NYWalker API" do
  include_context "api"

  # We only care about user info when posting. Creating an API key will be done
  # separately from authenticating.

  context "when POSTing" do
    let(:data_json) { accept.merge "CONTENT_TYPE" => "application/vnd.api+json" }
    let(:user) { create :user }

    xit "should give an error when the api_key is wrong" do
      post apiurl + "/", { username: user.username, api_key: "hi!" }.to_json, data_json
      expect(JSON.parse(last_response.body)["error"]).to eq "authentication_error"
    end

    it "should 200 when the api_key is correct" do
      post apiurl + "/", { username: user.username, api_key: "api_key" }.to_json, data_json
      expect(last_response.status).to eq 200
    end

  end

end
