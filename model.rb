require 'data_mapper'
require 'dm-validations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost:5432/nywalker.db")

class Instance
  include DataMapper::Resource

end

DataMapper.finalize # sets up the models for first time use.
# DataMapper.auto_upgrade!
