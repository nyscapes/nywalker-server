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

    it "should require that the type match '#{table}'"

    it "should create an instance of a #{table.singularize.capitalize}"

    it "should return the new instance of a #{table.singularize.capitalize}"

  end
  

  
end
