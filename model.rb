require 'data_mapper'
require 'dm-validations'
require 'dm-types'
require 'dm-postgis'
require 'active_support' # for the slugs
require 'active_support/inflector'
require 'active_support/core_ext/array/conversions'
require 'dotenv'

Dotenv.load

# ENV['DATABASE_URL'] is set in the file .env, which is hidden from git. See .env.example for an example of what it should look like.

if ENV['DATABASE_URL']
  DataMapper.setup(:default, ENV['DATABASE_URL'])
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

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost:5432/nywalker")

class Instance
  include DataMapper::Resource

  property :id, Serial
  property :page, Integer
  property :sequence, Integer
  property :text, String
  property :added_on, Date
  property :modified_on, Date

  belongs_to :place
  belongs_to :user
  belongs_to :book

  validates_presence_of :page
  validates_presence_of :book
  validates_presence_of :text

end

class Place
  include DataMapper::Resource

  property :id, Serial
  property :slug, String, key: true
  property :name, String
  property :added_on, Date
  property :lat, Float
  property :lon, Float
  property :geom, PostGISGeometry
  property :confidence, String
  property :source, Text
  property :geonameid, String
  property :bounding_box_string, Text

  belongs_to :user

  has n, :nicknames
  has 1, :bounding_box

  validates_presence_of :name
  validates_presence_of :lat
  validates_presence_of :lon
  validates_uniqueness_of :slug

end

class BoundingBox
  include DataMapper::Resource

  property :id, Serial
  property :geom, PostGISGeometry

  belongs_to :place

end

class Nickname
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  belongs_to :place

  validates_presence_of :name
end

class Book
  include DataMapper::Resource

  property :id, Serial
  property :slug, String, key: true
  property :author, String # should maybe be array, but...
  property :title, Text
  property :isbn, String
  property :year, Integer
  property :url, Text
  property :cover, Text
  property :added_on, Date
  property :modified_on, Date

  has n, :instances
  has n, :users, through: Resource

  validates_presence_of :author
  validates_presence_of :title
  validates_uniqueness_of :slug

end

class User
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :email, String
  property :username, String, key: true
  property :password, BCryptHash
  property :admin, Boolean, default: false
  property :added_on, Date
  property :modified_on, Date

  has n, :instances
  has n, :books, through: Resource
  has n, :places

  validates_uniqueness_of :username
  validates_presence_of :password
  validates_presence_of :email

end

DataMapper::Model.raise_on_save_failure = true # seriously, let's make debugging easy?

DataMapper.finalize # sets up the models for first time use.
# DataMapper.auto_migrate! # CREATE/DROP while killing the data
DataMapper.auto_upgrade! # Tries to make the schema match the model.
