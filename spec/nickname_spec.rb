describe Nickname do
  let(:place){ create :place }
  let(:nickname){ place.nicknames.first }

  context "When it is created, it" do
    it "raises Sequel::NotNullConstraintViolation if it belongs to no place" do
      expect{ Nickname.create instance_count: 0, name: "Zagmorf" }.to raise_error Sequel::NotNullConstraintViolation
    end

    it "fails if no 'name' is included" do
      expect{ Nickname.create instance_count: 0, place: place }.to raise_error Sequel::ValidationFailed
    end

    it "fails if no 'instance_count' is included" do
      expect{ Nickname.create name: "Zagmorf", place: place }.to raise_error Sequel::ValidationFailed
    end

  end

  describe "Methods" do
    describe "#list_string" do
      it "returns a string of the form 'nickname -- {nickname.place}'" do
        expect(nickname.list_string).to eq "#{nickname.name} -- {#{nickname.place.name}}"
      end
    end
  end

  describe "Queries" do
    describe "#sorted_by_instance_count" do
    end
  end

end
