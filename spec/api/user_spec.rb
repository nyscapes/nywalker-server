# frozen_string_literal: true
require "shared/contexts"
require "shared/routes"

describe "NYWalker API - /users" do
  #
  # Don't sweat this too much, as users are falling out of the api.
  #
  # context "in general" do
  #   it_should_behave_like "a route", "users"
  # end

  context "querying for a user" do
    include_context "api"

    context "who exists" do

      let(:user) { create(:user) }

      it "delivers the user's profile" do
        get apiurl + "/users/#{user.id}", {}, accept
        expect(JSON.parse(last_response.body)["data"]["attributes"]["name"]).to eq user.name
      end
    end

    context "who doesn't exist" do
      it "fails with a 404" do
        get apiurl + "/users/0", {}, accept
        expect(last_response.status).to eq 404
      end
    end
  end
end
