# frozen_string_literal: true
RSpec.shared_examples "a route" do |table, user|
  include_context "api"

  describe "GET #{table}" do

    before do
      faker = "fake_#{table.singularize}".to_sym
      if user == "user"
        owner = create(:user)
        create_list faker, 30, user: owner
      else 
        create_list faker, 30
      end
    end

    it "should give a 200" do
      getjsonapi "/#{table}"
      expect(last_response.status).to eq 200
    end

    it "should give a list of #{table}" do
      getjsonapi "/#{table}"
      expect(delivery["data"].length).to eq 30
    end

  end

  describe "GET #{table}/:id" do
    let(:item) { create table.singularize.to_sym }

    it "should give a 200 if the #{table.singularize} exists" do
      getjsonapi "/#{table}/#{item.id}"
      expect(last_response.status).to eq 200
    end

    it "should give a 404 if the #{table.singularize} does not exist" do
      getjsonapi "/#{table}/boogie"
      expect(last_response.status).to eq 404
    end

    it "should give a specific #{table.singularize}" do
      getjsonapi "/#{table}/#{item.id}"
      expect(delivery["data"]["id"].to_i).to eq item.id
    end

    it "should return type: '#{table}'" do
      getjsonapi "/#{table}/#{item.id}"
      expect(delivery["data"]["type"]).to eq table

    end

  end

  describe "POST #{table}" do
    include_context "posting"

    let(:payload) do 
      payload = { type: table, 
                   attributes: attributes_for(table.singularize.to_sym)
                 }
      if user == "user"
        owner = create :user
        payload[:attributes][:user_id] = owner.id
      end
      payload.to_json
    end

    it "should require that the type match '#{table}'" do
      post apiurl + "/#{table}", payload.sub(/#{table}/, "boogie"), data_json
      expect(JSON.parse(last_response.body)["error"]).to eq "invalid_type"
    end

    it "should create an instance of a #{table.singularize.capitalize} & return it" do
      post apiurl + "/#{table}", payload, data_json
      expect(JSON.parse(last_response.body)["data"]["id"].to_i).to eq table.singularize.classify.constantize.last.id
    end

    it "catches the validation error if attributes are missing" do
      bad_payload = { type: table, attributes: {} }
      post apiurl + "/#{table}", bad_payload.to_json, data_json
      expect(JSON.parse(last_response.body)["error"]).to eq "Sequel::ValidationFailed"
    end

  end

  describe "PATCH #{table}" do
    include_context "posting"
    let(:item) { create table.singularize.to_sym }
    let(:payload) do
      { type: table,
        id: item.id,
        attributes: attributes_for("edit_#{table.singularize}".to_sym)
      }.to_json
    end

    it "should have an id"

    it "should 404 without an id" do
      patch apiurl + "/#{table}/1", payload, data_json
      expect(last_response.status).to eq 404
    end

    it "should require that the type match '#{table}'" do
      patch apiurl + "/#{table}/#{item.id}", payload.sub(/#{table}/, "boogie"), data_json
      puts last_response.body
      puts last_response.status
      expect(JSON.parse(last_response.body)["error"]).to eq "invalid_type"
    end

    it "should respond with a 200" do
      patch apiurl + "/#{table}/#{item.id}", payload, data_json
      expect(last_response.status).to eq 200
    end

    it "should update the resource"

    it "should return the updated resource"

    it "should not interpret missing attributes as nulls"

  end

  describe "DELETE #{table}/:id" do
    include_context "posting"

    let(:item) { create table.singularize.to_sym }

    it "should respond with a 204" do
      delete apiurl + "/#{table}/#{item.id}", {}, accept
      expect(last_response.status).to eq 204
    end

    it "should delete the item" do
      delete apiurl + "/#{table}/#{item.id}", {}, accept
      expect(table.singularize.classify.constantize[item.id]).to be_nil
    end

  end
  

  
end
