require "shared/contexts"
require "shared/routes"

describe "NYWalker API - /places" do
  context "in general" do
    it_should_behave_like "a route", "places", "user"
  end
  # let(:place){ create :place }

  context "posting" do
    include_context "posting"
    let(:place_data) { 
      data[:type] = "place"
      data[:attributes] = { name: "New York City" } 
      data.to_json 
    }

    context "with badly formed data" do

      it "gives a invalid_type error if the type is not 'place'" do
        post apiurl + "/places", place_data.sub(/place/, "boogie"), data_json
        expect(JSON.parse(last_response.body)["error"]).to eq "invalid_type"
      end

      it "catches the validation error if attributes are missing"

      it "catches the validation error if the slug is not unique"
    end

    it "creates a Place"

  end

  context "patching" do
    include_context "posting"
    let(:data_json) { accept.merge "CONTENT_TYPE" => "application/vnd.api+json" }

    it "404s if there’s no such place" #do
    #   patch apiurl + "/places/12345", place_data, data_json
    #   expect(last_response.status).to eq 404
    # end
    
    it "updates the attribute"

    it "updates the modified_on value"

  end

  context "deleting" do
    include_context "posting"

    it "deletes the place"

  end

end
