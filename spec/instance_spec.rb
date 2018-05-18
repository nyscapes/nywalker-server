# frozen_string_literal: true
describe Instance do

  context "When it is created, it" do
    let(:instance){ build :instance }
    
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
      expect(instance.added_on).to be_a Date
    end

    it "pushes the sequence of instances after it on the same page" do
      old_instance = instance
      create :instance, book: book, sequence: old_instance.sequence
      expect(Instance[old_instance.id].sequence).to eq(old_instance.sequence + 1)
    end

    it "has an #modified_on" do
      expect(instance.modified_on).to be_a Date
    end
  end

  context "When it is edited, it" do
    let(:instance){ create :instance }

    # it "reduces the Nickname.instance_count if the name changes"
      # This seems impossible. around_save already gets the new text, 
      # not the old text. This will have to be done in the route.

    it "has a #modified_on" do
      instance.update(note: "Note text.")
      instance.save
      expect(instance.modified_on).to be_a Date
    end
  end

  context "When it is destroyed, it" do
    let(:instance){ create :instance }

    it "reduces the Nickname.instance_count by 1" do
      nick = Nickname.where(place: instance.place, name: instance.text).first
      nick.update(instance_count: 5)
      instance.destroy
      expect(Nickname[nick.id].instance_count).to eq 4
    end
  end

  describe "Methods"

  describe "Queries" do
    let(:book){ create :book }

    describe "#all_sorted_for_book(book)" do
      it "requires a Book passed to it" do
        expect{Instance.all_sorted_for_book("string")}.to raise_error ArgumentError
      end

      it "only returns instances for the book given it" do
        create_list :instance, 15, book: book
        second_book = create :second_book
        create_list :instance, 15, book: second_book
        instances = Instance.all_sorted_for_book(book)
        expect(instances.map{|i| i.book}.uniq[0]).to eq book
      end

      it "returns instances in page order" do
        create_list :instance, 15, book: book
        instances = Instance.all_sorted_for_book(book)
        expect(instances.first.page). to be <= instances.last.page
      end
    end

    describe "#last_instance_for_book(book)" do
      it "requires a Book passed to it" do
        expect{Instance.last_instance_for_book("string")}.to raise_error ArgumentError
      end

      it "returns the most recently modified instance" do
        instance = create :instance, book: book
        create_list :instance, 15, book: book
        instance.text = "new place name"
        instance.save
        expect(Instance.last_instance_for_book book).to eq instance
      end
    end

    describe "#later_instances_of_same_page(book, page, seq)" do
      it "requires a Book, page, and sequence" do
        expect{Instance.later_instances_of_same_page(book, "string", "string")}.to raise_error ArgumentError
      end

      it "delivers instances that are all on the same page" do
        create_list :instance, 15, page: 10, book: book
        expect(Instance.later_instances_of_same_page( book, 10, 1 ).map{|i| i.page}.uniq).to contain_exactly 10
      end
    end


    describe "#all_users_sorted_by_count(book)" do
      let(:user) { create :user }

      it "returns an Array of Instances with a 'values' hash with a 'user_id' and 'count' keys" do
        create_list :instance, 15, book: book, user: user
        expect(Instance.all_users_sorted_by_count.first.values).to eq({user_id: user.id, count: Instance.count})
      end

      it "only returns instances for users from the book given it" do
        create_list :instance, 15, book: book, user: user
        second_book = create :second_book
        create_list :instance, 15, book: second_book, user: user
        expect(Instance.count).to eq 30
        expect(Instance.all_users_sorted_by_count(book).first.values).to eq({user_id: user.id, count: 15})
      end
    end

    describe "#nickname_instance_count(text, place)" do
      it "requires a Place passed to it" do
        expect{Instance.nickname_instance_count("string", "place")}.to raise_error ArgumentError
      end

      it "returns a number" do
        text = "Random nickname-#{rand(1000)}"
        place = create :place
        create :instance, place: place, book: book, text: text
        expect(Instance.nickname_instance_count(text, place)).to eq 1
      end
    end
  end

end

