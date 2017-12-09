describe Place do
  let(:place){ create :place }

  context "When it is created, it" do
    it "has one nickname" do
      expect(place.nicknames.length).to eq 1
    end

    it "has a nickname that is equal to its name" do
      expect(place.nicknames[0].name).to eq place.name
    end
  end
  
  context "when it is edited, it" do
    it "does not duplicate the nickname creation if the name has not changed" do
      place.update(lat: 50)
      expect(Nickname.where(place: place, name: place.name).all.length).to eq 1
    end
  end

  context "When it is destroyed, it" do
    it "fails if there are instances" do
      create :instance, place: place
      expect{ place.destroy }.to raise_error(/Cannot delete/)
    end
  end

  describe "Methods" do
    let(:book) { create :book }
    let(:second_book) { create :second_book }
    let(:second_place) { create :place }

    before(:each) do
      create_list :instance, 2, book: book, place: place, text: "Bingo"
      create_list :instance, 2, book: second_book, place: place, text: "Bingo"
      create_list :instance, 4, book: book, place: place, text: "Zagmorf"
      create_list :instance, 4, book: second_book, place: place, text: "Zagmorf"
    end
      
    
    describe "#instances_per(book)" do
      it "gives all of the instances when 'book' is undefined" do
        expect(place.instances_per.length).to eq 12
      end

      it "gives the instances for 'book' when it is defined" do
        expect(place.instances_per(book).length).to eq 6
      end

    end

    describe "#instances_by_names(book)" do
      it "returns an array in the form of '[[nickname1, instance_count], …]'" do
        expect(place.instances_by_names).to contain_exactly ["Bingo", 4], ["Zagmorf", 8]
      end

      it "limits itself to 'book' when that is passed" do
        expect(place.instances_by_names book).to contain_exactly ["Bingo", 2], ["Zagmorf", 4]
      end

    end

    describe "#names_to_sentence(book)" do
      before (:each) do
        create_list :instance, 4, book: second_book, place: place, text: "Bhalu"
      end

      it "returns a string of names" do
        expect(place.names_to_sentence).to match(/\w+, \w+, and \w+/)
      end

      it "limits itself to 'book' when that is passed" do
        expect(place.names_to_sentence book).to match(/\w+ and \w+/)
      end

    end
  end

  describe "Queries" do

    describe "#all_with_instances(book, real)" do
      let(:book) { create :book }
      let(:second_book) { create :second_book }
      let(:second_place) { create :place }
      let(:third_place) { create :place, confidence: "0" }

      before(:each) do
        create_list :instance, 2, book: book, place: place, text: "Bingo"
        create_list :instance, 2, book: book, place: third_place, text: "Bingo"
        create_list :instance, 2, book: second_book, place: place, text: "Bingo"
        create_list :instance, 4, book: book, place: place, text: "Zagmorf"
        create_list :instance, 4, book: second_book, place: place, text: "Zagmorf"
      end

      it "returns all of the places with instances when 'book' is 'all' and 'real' is false" do
        expect(Place.all_with_instances("all", false)).to contain_exactly place, third_place
      end

      it "returns only the real places with instances when 'real' is true" do
        expect(Place.all_with_instances("all", true)).to contain_exactly place
      end

      it "limits itself to 'book' when that is passed" do
        create_list :instance, 2, book: book, place: second_place, text: "Bingo"
        expect(Place.all_with_instances(book)).to contain_exactly place, second_place
      end
    end

  end

end
