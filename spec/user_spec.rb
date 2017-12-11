describe User do

  context "When it is created, it"

  context "When it is saved, it"

  context "When it is edited, it"

  context "When it is destroyed, it"

  describe "Methods" do
    describe "#has_key?"

    describe "#admin?"

    describe "#fullname" do
      it "returns 'firstname' when 'lastname' is nil" do
        user = create :user, lastname: nil
        expect(user.fullname).to eq user.firstname
      end

      it "returns 'lastname' when 'firstname' is nil" do
        user = create :user, firstname: nil
        expect(user.fullname).to eq user.lastname
      end

      it "returns 'name' when the other names are nil" do
        user = create :user, firstname: nil, lastname: nil
        expect(user.fullname).to eq user.name
      end

      it "returns both names when they exist" do
        user = create :user
        expect(user.fullname).to eq "#{user.firstname} #{user.lastname}"
      end
    end

    describe "#fullname_lastname_first" do
      it "returns 'firstname' when 'lastname' is nil" do
        user = create :user, lastname: nil
        expect(user.fullname_lastname_first).to eq user.firstname
      end

      it "returns 'lastname' when 'firstname' is nil" do
        user = create :user, firstname: nil
        expect(user.fullname_lastname_first).to eq user.lastname
      end

      it "returns 'name' when the other names are nil" do
        user = create :user, firstname: nil, lastname: nil
        expect(user.fullname_lastname_first).to eq user.name
      end

      it "returns both names when they exist" do
        user = create :user
        expect(user.fullname_lastname_first).to eq "#{user.lastname}, #{user.firstname}"
      end

    end
  end

  describe "Queries"

end
