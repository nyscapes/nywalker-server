require 'sequel'
require 'dotenv'

Dotenv.load # This is weird that it's called here, because app.rb uses it.

# ENV['DATABASE_URL'] is set in the file .env, which is hidden from git. See .env.example for an example of what it should look like.

if ENV['DATABASE_URL']
  DB = Sequel.connect(ENV['DATABASE_URL'])
else
  raise "ENV['DATABASE_URL'] must be set. Edit your '.env' file to do so."
end

# The local install requires running `createdb nywalker`, assuming you name
# the database "nywalker".
#
# Furthermore, we require adding postGIS. Open the db with `psql nywalker`
# and then run `CREATE EXTENSION postgis;` on the dev machine. PostGIS is
# available only on pro installs on heroku, which is why this can't be
# deployed there. Oops. 
#
# I mean, if you want to pay…

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
      nickname = Nickname.create(name: self.text, place: self.place)
    end
    nickname.update instance_count: self.class.nickname_instance_count(self.text, self.place)
    # # increase the sequences of the other instances
    sequence_counter = self.sequence
    self.class.later_instances_of_same_page(self.book, self.page, self.sequence).select{ |i| i.id != self.id }.each_with_index do |later_instance, index|
      later_instance.update(sequence: sequence_counter + 1 + index)
    end
  end

  def before_update
    self.modified_on = Time.now
  end

  def validate
    super
    validates_presence [:page, :book, :text]
  end

  dataset_module do

    def all_sorted_for_book(book)
      where(book: book)
        .order(:page, :sequence)
        .all
    end

    def last_instance_for_book(book)
      where(book: book)
        .order(:modified_on, :added_on, :page, :sequence)
        .last
    end

    def later_instances_of_same_page(book, page, seq)
      where(book: book, page: page)
        .where{ sequence >= seq }
        .all
    end
    
    def nickname_instance_count(text, place)
      where(text: text, place: place)
        .all
        .length
    end

  end

  def before_destroy
    n = Nickname.where(name: self.text, place: self.place).first
    n.instance_count = n.instance_count - 1
    n.save
    Instance.where(book: self.book, page: self.page).where{ sequence > self.sequence }.each do |instance|
      instance.update(sequence: instance.sequence - 1)
    end
  end

end

class Place < Sequel::Model
  plugin :validation_helpers

  many_to_one :user
  one_to_many :nicknames
  one_to_many :instances

  def validate
    super
    validates_presence [:name, :slug]
    validates_unique :slug, message: "Place slug is not unique"
  end

  def instances_per
    if @book
      self.instances.select{ |i| i.book_id == @book.id }
    else
      self.instances
    end
  end

  def instances_by_names
    instances = self.instances_per
    # array like [["New York", 41], ["New York City", 6], ["NEW YORK FUCKIN’ CITY", 1]]
    place_names = instances.map{|i| i.text}.uniq.map{|n| [n, instances.select{|i| i.text == n}.count]}
    string = "<ul style='margin-left: 1em; padding: 0; margin-bottom: 0px;'>"
    place_names.each{|name| string = string + "<li>#{name[0]}: #{name[1]}</li>"}
    string = string + "</ul>"
    string.gsub(/"/, "")
  end

  def names_to_sentence
    if @book
      @book.instances.select{ |i| i.place == self }.map{ |i| i.text }.uniq.to_sentence
    else
      self.nicknames.select{ |n| n.instance_count > 0 }.map{ |n| n.name }.to_sentence
    end
  end
  
  # def demolish!
  #   self.nicknames.each{ |n| n.destroy! }
  #   self.destroy!
  # end

  # def merge(oldslug)
  #   oldplace = Place.first slug: oldslug
  #   if oldplace.nil?
  #     puts "Could not find '#{oldslug}'"
  #   else
  #     Instance.all(place: oldplace).each do |instance|
  #       instance.update(place: self)
  #     end
  #     oldplace.demolish!
  #   end
  # end
  
  dataset_module do
    
    def all_with_instances(book = "all", real = true)
      if book == "all"
      q = where(id: Instance.select(:place_id))
      else
      q = where(id: Instance.where(book: book).select(:place_id))
      end
      if real
        q = q.where(confidence:/[123]/)
      end
      q.all
    end

  end

  def before_destroy
    if self.instances.count != 0
      raise "There are instances attached to this place. Cannot delete"
    else
      self.nicknames_dataset.destroy
    end
  end

end

class Flag < Sequel::Model
  plugin :validation_helpers

  many_to_one :user

  def validate
    super
    validates_presence [:object_type, :object_id]
  end

end

class Nickname < Sequel::Model
  plugin :validation_helpers

  many_to_one :place

  def validate
    super
    validates_presence [:name]
  end

  # def instance_count_query
  #   Instance.all(place: self.place, text: self.name).count
  # end

  def list_string
    "#{self.name} -- {#{self.place.name}}"
  end
end

class Special < Sequel::Model
  plugin :validation_helpers

  one_to_one :book

  def validate
    super
    validates_presence [:field]
  end

end

class Book < Sequel::Model
  plugin :validation_helpers

  one_to_one :special
  one_to_many :instances
  many_to_many :users, left_key: :book_id, right_key: :user_id, join_table: :book_users

  def validate
    super
    validates_presence [:author, :title, :slug]
    validates_unique :slug, message: "Book slug is not unique"
  end

  def total_pages
    instances = Instance.where(book: self).map(:page).sort
    instances.length == 0 ? 0 : instances.last - instances.first
  end

  def last_instance
    Instance.last_instance_for_book(self)
  end

  dataset_module do

    def all_with_instances_sorted
      where(id: Instance.select(self))
        .order(:title)
        .all
    end

  end

end

class User < Sequel::Model
  plugin :validation_helpers
  plugin :secure_password

  one_to_many :instances
  many_to_many :books, left_key: :book_id, right_key: :user_id, join_table: :book_users
  one_to_many :places
  one_to_many :flags

  def validate
    super
    validates_presence [:username, :email]
    validates_unique [:email]
  end

  def has_key?(key)
    true
  end

  def admin?
    self.admin
  end

end
