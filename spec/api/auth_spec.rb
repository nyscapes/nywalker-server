require_relative "./shared.rb"

describe "NYWalker API" do
  include_context "api"

  context "logging in" do

    context "with no payload" do
      it "fails" do
        post apiurl + "/token", {}, accept
        expect(last_response.status).to eq 400
      end

      it "returns an error of 'no_request_payload'" do
        post apiurl + "/token", {}, accept
        expect(JSON.parse(last_response.body)["error"]).to eq "no_request_payload"
      end
    end

    context "with a payload" do

      let(:data) { '{"grant_type":"password", "username":"beetlejuice", "password":"beetlejuice"}' }
      let(:data_json) { accept.merge "CONTENT_TYPE" => "application/vnd.api+json" }

      it "fails when the data is not JSONAPI" do
        post apiurl + "/token", data, accept
        expect(last_response.status).to eq 415
      end

      it "sends a useful error on authentication issue" do
        post apiurl + "/token", data, data_json
        expect(JSON.parse(last_response.body)["error"]).to eq "invalid_grant"
      end

      it "authenticates and returns an access token" do
        user = create(:user)
        allow(user).to receive(:authenticate).and_return(user)
        post apiurl + "/token", data, data_json
        expect(JSON.parse(last_response.body)["access_token"]).not_to be_empty
      end

      it "sets the access token" do
        redis = Redis.new
        post apiurl + "/token", data, data_json
        expect(JSON.parse(last_response.body)["access_token"]).to eq redis.get("beetlejuice_access_token")

      end
    end
  end

  context "logging out" do
    let(:user) { create(:user) }
    let(:data) { { account_id: user.id, access_token: "secret!" }.to_json }
    let(:data_json) { accept.merge "CONTENT_TYPE" => "application/vnd.api+json" }
    let(:redis) { Redis.new }

    before do
      redis.set "#{user.username}_access_token", "secret!"
    end

    it "sends a request to /revoke" do
      post apiurl + "/revoke", {}, accept
      expect(last_response.status).to eq 200
    end

    it "destroys the access token" do
      post apiurl + "/revoke", data, data_json
      expect(redis.get "#{user.username}-access-token").to be_nil
    end
  end
end
