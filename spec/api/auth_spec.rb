require_relative "./shared.rb"

describe "NYWalker API" do
  include_context "api"

  # We only care about user info when posting. Creating an API key will be done
  # separately from authenticating.

  context "when POSTing" do
    let(:data_json) { accept.merge "CONTENT_TYPE" => "application/vnd.api+json" }
    let(:user) { create :user }
    let(:redis) { Redis.new }

    it "should give an error when the access token is wrong" do
      redis.mset "#{user.username}_access_token", SecureRandom.urlsafe_base64
      post apiurl + "/", { username: user.username, access_token: "hi!" }.to_json, data_json
      expect(JSON.parse(last_response.body)["error"]).to eq "authentication_error"
    end

    it "should 200 when the access token is correct" do
      redis.mset "#{user.username}_access_token", "hi!"
      post apiurl + "/", { username: user.username, access_token: "hi!" }.to_json, data_json
      expect(last_response.status).to eq 200
    end

  end

end
