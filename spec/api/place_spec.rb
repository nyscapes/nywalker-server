require_relative "./shared.rb"

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

end
