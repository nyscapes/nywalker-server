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

  many_to_one :place
  one_to_one :user
  one_to_one :book

  # validates_presence_of :page
  # validates_presence_of :book
  # validates_presence_of :text

end

class Place < Sequel::Model

  many_to_one :user
  one_to_many :nicknames
  one_to_many :instances

  # validates_presence_of :name
  # validates_uniqueness_of :slug

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

  many_to_one :user

  # validates_presence_of :object_type
  # validates_presence_of :object_id

end

class Nickname < Sequel::Model

  many_to_one :place

  # validates_presence_of :name

  # def instance_count_query
  #   Instance.all(place: self.place, text: self.name).count
  # end

  # def list_string
  #   "#{self.name} -- {#{self.place.name}}"
  # end
end

class Special < Sequel::Model

  one_to_one :book

  # validates_presence_of :field
end

class Book < Sequel::Model

  one_to_one :special
  one_to_many :instances
  many_to_many :users, left_key: :user_id, right_key: :book_id, join_table: :book_users

  # validates_presence_of :author
  # validates_presence_of :title
  # validates_uniqueness_of :slug

  # def total_pages
  #   instances = Instance.all(book: self).map{ |i| i.page }.sort
  #   instances.length == 0 ? 0 : instances.last - instances.first
  # end

end

class User < Sequel::Model

  one_to_many :instances
  many_to_many :books, left_key: :user_id, right_key: :book_id, join_table: :book_users
  one_to_many :places
  one_to_many :flags

  # validates_uniqueness_of :username
  # validates_presence_of :password
  # validates_presence_of :email

  # def authenticate(attempted_password)
  #   self.password == attempted_password ? true : false
  # end

end
