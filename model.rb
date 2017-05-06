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

  def validate
    super
    validates_presence [:page, :book, :text]
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
    validates_unique :slug
  end

  # def instances_per
  #   if @book
  #     self.instances.select{ |i| i.book_id == @book.id }
  #   else
  #     self.instances
  #   end
  # end

  # def instances_by_names
  #   instances = self.instances_per
  #   # array like [["New York", 41], ["New York City", 6], ["NEW YORK FUCKIN’ CITY", 1]]
  #   place_names = instances.map{|i| i.text}.uniq.map{|n| [n, instances.select{|i| i.text == n}.count]}
  #   string = "<ul style='margin-left: 1em; padding: 0; margin-bottom: 0px;'>"
  #   place_names.each{|name| string = string + "<li>#{name[0]}: #{name[1]}</li>"}
  #   string = string + "</ul>"
  #   string.gsub(/"/, "")
  # end

  # def names_to_sentence
  #   if @book
  #     @book.instances.select{ |i| i.place == self }.map{ |i| i.text }.uniq.to_sentence
  #   else
  #     self.nicknames.select{ |n| n.instance_count > 0 }.map{ |n| n.name }.to_sentence
  #   end
  # end
  
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

  # def list_string
  #   "#{self.name} -- {#{self.place.name}}"
  # end
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
  many_to_many :users, left_key: :user_id, right_key: :book_id, join_table: :book_users

  def validate
    super
    validates_presence [:author, :title, :slug]
    validates_unique :slug
  end

  # def total_pages
  #   instances = Instance.all(book: self).map{ |i| i.page }.sort
  #   instances.length == 0 ? 0 : instances.last - instances.first
  # end

end

class User < Sequel::Model
  plugin :validation_helpers

  one_to_many :instances
  many_to_many :books, left_key: :user_id, right_key: :book_id, join_table: :book_users
  one_to_many :places
  one_to_many :flags

  def validate
    super
    validates_presence [:username, :password, :email]
    validates_unique [:email]
  end

  # def authenticate(attempted_password)
  #   self.password == attempted_password ? true : false
  # end

end
