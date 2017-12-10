class Instance < Sequel::Model
  plugin :validation_helpers

  many_to_one :place
  many_to_one :user
  many_to_one :book

  def after_create
    super
    # Add a time
    self.added_on = Time.now
  end

  def after_save
    super
    # See if the nickname is new or not
    nickname = Nickname.where(name: self.text, place: self.place).first
    if nickname.nil?
      nickname = Nickname.create(name: self.text, place: self.place, instance_count: 1)
    end
    nickname.update instance_count: self.class.nickname_instance_count(self.text, self.place)
    # # increase the sequences of the other instances
    sequence_counter = self.sequence
    self.class.later_instances_of_same_page(self.book, self.page, self.sequence).select{ |i| i.id != self.id }.each_with_index do |later_instance, index|
      later_instance.update(sequence: sequence_counter + 1 + index)
    end
    self.modified_on = Time.now
  end

  def validate
    super
    validates_presence [:page, :text]
  end

  dataset_module do

    def all_sorted_for_book(book)
      raise ArgumentError.new( "'book' must be a Book" ) if book.class != Book
      where(book: book)
        .order(:page, :sequence)
        .all
    end

    def last_instance_for_book(book)
      raise ArgumentError.new( "'book' must be a Book" ) if book.class != Book
      where(book: book)
        .order(Sequel.desc(:modified_on), :page, :sequence)
        .last
    end

    def later_instances_of_same_page(book, page, seq)
      raise ArgumentError.new( "'book' must be a Book" ) if book.class != Book
      raise ArgumentError.new( "'page' and 'sequence' must be Fixnum" ) if page.class != Fixnum || seq.class != Fixnum
      where(book: book, page: page)
        .where{ sequence >= seq }
        .all
    end
    
    def nickname_instance_count(text, place)
      raise ArgumentError.new( "'place' must be a Place" ) if place.class != Place
      where(text: text, place: place)
        .all
        .length
    end

  end

  def before_destroy
    n = Nickname.where(name: self.text, place: self.place).first
    n.update instance_count: n.instance_count - 1
    Instance.where(book: self.book, page: self.page).where{ sequence > self.sequence }.each do |instance|
      instance.update(sequence: instance.sequence - 1)
    end
  end
end
