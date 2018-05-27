# frozen_string_literal: true

require "shared/slug"

describe Book do
  let(:book){ create :book }

  context "when it is saved, it" do
    it_should_behave_like "it has a slug", "place"
  end

  context "Methods" do
    describe "#last_instance" do
      it "returns the last instance"
    end
    describe "#user_sentences" do
      it "returns a list of users who contributed to the book."
    end
    describe "#all_places" do
      it "returns an array of pretend places"
      it "that include the instance_count_by_name array"
      it "includes only places from the book"
    end
    describe "#mappable_places" do
      it "only includes places with a confidence not 0"
    end
    describe "#unmappable_places" do
      it "only includes places with a confidence of 0"
    end
  end

  context "API Methods" do
    describe "#name"
    describe "#total_pages"
    describe "#instances_per_page"
    describe "#instance_count"
    describe "#special_field"
    describe "#special_help_text"
  end

  describe "Queries" do
  end

end
