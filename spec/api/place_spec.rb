# frozen_string_literal: true
require "shared/contexts"
require "shared/routes"

describe "NYWalker API - /places" do
  context "in general" do
    it_should_behave_like "a route", "places", "user"
  end
  # let(:place){ create :place }

  context "deleting" do
    it "should catch errors if there are still instances attached."
  end

end
