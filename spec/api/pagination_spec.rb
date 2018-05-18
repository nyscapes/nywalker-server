# frozen_string_literal: true
require "shared/contexts"

describe "NYWalker API" do
  include_context "api"

  context ", when asking for pagination" do

    it "responds with a meta object" do
      get apiurl + "/places?data_page=1&page_size=10", {}, accept
      expect(JSON.parse(last_response.body)["meta"]).not_to be_empty
    end

    it "provides a total_pages attribute in the meta object" do
      get apiurl + "/places?data_page=1&page_size=10", {}, accept
      expect(JSON.parse(last_response.body)["meta"]["total_pages"]).not_to be_nil
    end

    it "ensures that the page size attribute is a number" do
      get apiurl + "/places?data_page=foo&page_size=bar", {}, accept
      expect(last_response.status).to be 400
    end

    it "rounds total_pages up" do
      allow(Place).to receive(:count).and_return(35)
      get apiurl + "/places?data_page=1&page_size=10", {}, accept
      expect(JSON.parse(last_response.body)["meta"]["total_pages"]).to eq 4
    end

  end

  describe '#paginator(table, page, page_size)' do
    
    it 'requires that the table be valid'

    it 'requires numbers from the other two be integers' do
      get apiurl + "/places?data_page=foo&page_size=bar", {}, accept
      expect(last_response.status).to be 400
    end

    it 'returns an array the size of page_size' do
      create_list :place, 30
      get apiurl + "/places?data_page=1&page_size=5", {}, accept
      expect(JSON.parse(last_response.body)["data"].length).to eq 5
    end

  end

end
