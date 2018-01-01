describe "NYWalker API" do
  let(:apiurl) { "/api/v1" }
  let(:accept) { { "HTTP_ACCEPT" => "application/vnd.api+json" } }

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
    end
  end

  context "logging out" do
    it "sends a request to /revoke" do
      post apiurl + "/revoke", {}, accept
      expect(last_response.status).to eq 200
    end
  end
end
