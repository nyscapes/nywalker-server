require 'spec_helper'

describe "NYWalker API" do

  let(:apiurl) { "/api/v1" }
  let(:accept) { { "HTTP_ACCEPT" => "application/vnd.api+json" } }

  context ", when asking for pagination" do

    let(:user) { create(:user) }
    let(:places) { create_list(:place, 30, user: user) }

    it "responds with a meta object" do
      get apiurl + "/places?data_page=0&page_size=10", {}, accept
      expect(JSON.parse(last_response.body)["meta"]).not_to be_empty
    end

    it "provides a total_pages attribute in the meta object" do
      get apiurl + "/places?data_page=0&page_size=10", {}, accept
      expect(JSON.parse(last_response.body)["meta"]["total_pages"]).not_to be_nil
    end

    it "ensures that the page size attribute is a number" do
      get apiurl + "/places?data_page=foo&page_size=bar", {}, accept
      expect(last_response.status).to be 400
    end

    it "rounds total_pages up" do
      allow(Place).to receive(:count).and_return(35)
      get apiurl + "/places?data_page=0&page_size=10", {}, accept
      expect(JSON.parse(last_response.body)["meta"]["total_pages"]).to be 4
    end

    it "gives the first set of records when the page is 0" do

    end

  end
end


