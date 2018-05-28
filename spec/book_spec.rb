# frozen_string_literal: true

require "shared/slug"

describe Book do
  let(:book){ create :book }

  context "when it is saved, it" do
    it_should_behave_like "it has a slug", "place"
  end

  context "Methods" do
    let(:second_book) { create :second_book }
    let(:place) { create :place }
    let(:second_place) { create :place }
    let(:no_place) { create :no_place }

    before(:each) do
      create :instance, book: book, place: place, text: "Istanbul"
      create :instance, book: book, place: place, text: "Constantinople"
      create :instance, book: book, place: place, text: "Istanbul"
      create :instance, book: second_book, place: place, text: "Istanbul"
      create :instance, book: book, place: second_place
      create :instance, book: book, place: no_place
      # create_list :instance, 15, book: book
    end

    describe "#all_places" do
      it "returns an array of places" do
        # place, second_place, and no_place
        expect(book.all_places.length).to eq 3 
      end

      it "that include the instance_count_by_name array" do
        expect(book.all_places.map{|p| p[:instance_count_by_name].class}).to eq  [Array, Array, Array]
      end
      it "includes only places from the book" do
        third_place = create :place
        expect(book.all_places.map{|p| p[:id]}).to_not include third_place.id
      end
    end
    describe "#mappable_places" do
      it "only includes places with a confidence not 0"
    end
    describe "#unmappable_places" do
      it "only includes places with a confidence of 0"
    end
  end

  context "API Methods" do
    describe "#last_instance" do
      it "returns the last instance"
    end
    describe "#user_sentences" do
      it "returns a list of users who contributed to the book."
    end
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
