describe Instance do

  context "When it is created, it" do
    let(:instance){ build :instance }#, place: nil }
    
    it "has a text" do
      expect(instance).to respond_to(:text)
    end

    it "does not have an #added_on" do
      expect(instance.added_on).to be nil
    end

  end

  context "When it is saved, it" do
    let(:book){ create :book }
    let(:instance){ create :instance, book: book } 

    it "has an associated Nickname" do
      nickname = Nickname.where(name: instance.text, place: instance.place).first
      expect(nickname).to be_an_instance_of Nickname
    end

    it "has an #added_on" do
      expect(instance.added_on).to be_an_instance_of Date
    end

    it "pushes the sequence of instances after it on the same page" do
      old_instance = instance
      create :instance, book: book, sequence: old_instance.sequence
      expect(Instance[old_instance.id].sequence).to eq(old_instance.sequence + 1)
    end

  end

end

