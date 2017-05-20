require 'sequel'
require 'sequel/extensions/pagination'
require 'will_paginate'
require 'will_paginate/collection'
require 'will_paginate/sequel'
require 'will_paginate/array' # might not be the best place…
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

Sequel::Model.plugin :tactical_eager_loading # reduce queries.

# Sequel.extension :inflector
DB.extension(:pagination) # load paginator

class Instance < Sequel::Model
  plugin :validation_helpers

  many_to_one :place
  many_to_one :user
  many_to_one :book

  def validate
    super
    validates_presence [:page, :book, :text]
  end

  def lat
    self.place.lat
  end

  def lon
    self.place.lon
  end

  def place_name
    self.place.name
  end

  dataset_module do

    def all_sorted_for_book(book)
      where(book: book)
        .order(:page, :sequence)
        .all
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
    validates_unique :slug
  end

  def instance_count
    self.instances.length
  end

  def nickname_sentence
    self.nicknames.map{ |n| n.name }.to_sentence
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

  def instance_count_query
    Instance.where(place: self.place, text: self.name).count
  end

  def list_string
    "#{self.name} -- {#{self.place.slug}}"
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
  many_to_many :users, left_key: :user_id, right_key: :book_id, join_table: :book_users

  def validate
    super
    validates_presence [:author, :title, :slug]
    validates_unique :slug
  end

  def total_pages
    instances = Instance.where(book: self).map(:page).sort
    instances.length == 0 ? 0 : instances.last - instances.first
  end

  def instance_count
    self.instances.count
  end

  def instances_per_page
    self.total_pages == 0 ? pages = 1.0 : pages = self.total_pages.to_f
    (self.instances.count/pages).round(2)
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
  many_to_many :books, left_key: :user_id, right_key: :book_id, join_table: :book_users
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
