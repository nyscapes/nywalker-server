require_relative './shared.rb'

describe "NYWalker API - /places" do
  include_context "api"
  let(:place){ create :place }

  context "when the point is /places/:place_id" do
    it "returns the place with that id" do
      getjsonapi "/places/", place.id
      expect(delivery["data"]["attributes"]["name"]).to eq place.name
    end

    it "404s when there is no place with that id" do
      getjsonapi "/places/", place.id + 1
      expect(last_response.status).to eq 404
    end
  end

  context "when sent without parameters" do
    it "returns all of the places" do
      create_list :place, 30
      getjsonapi "/places"
      expect(delivery["data"].length).to eq 30
    end
  end

  context "when sent with params[:slug]" do
    it "returns the place with that slug" do
      nozgy = create :place, name: "Nozgy York"
      getjsonapi "/places", slug: nozgy.slug
      expect(delivery["data"]["attributes"]["name"]).to eq nozgy.name
    end
  end

  context "when sent with params[:name]" do
    it "returns places that match the name." do
      create :place, name: "Nozgy York"
      create :place, name: "Nozgee York"
      create :place, name: "Shimbam"
      getjsonapi "/places", name: "Nozg"
      expect(delivery["data"].length).to eq 2
    end
  end

  context "posting" do

    context "with no place_id" do
      it "404s" do
        post apiurl + "/places", {}, accept
        expect(last_response.status).to eq 404
      end
    end

    context "with no payload" do
      it "fails" do
        post apiurl + "/places/#{place.id}", {}, accept
        expect(last_response.status).to eq 400
      end

      it "returns an error of 'no_request_payload'" do
        post apiurl + "/places/#{place.id}", {}, accept
        expect(JSON.parse(last_response.body)["error"]).to eq "no_request_payload"
      end
      

    end

    context "with a payload" do
      # let(:data) { '{"lat": 10, "lon": 10}' }
      let(:data) { { lat: 10, lon: 10 }.to_json }
      let(:data_json) { accept.merge "CONTENT_TYPE" => "application/vnd.api+json" }

      it "fails when the data is not JSONAPI" do
        post apiurl + "/places/#{place.id}", data, accept
        expect(last_response.status).to eq 415
      end

      it "404s if there’s no such place" do
        post apiurl + "/places/12345", data, data_json
        expect(last_response.status).to eq 404
      end

    end

  end

end
