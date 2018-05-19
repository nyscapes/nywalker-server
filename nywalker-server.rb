# frozen_string_literal: true
# encoding: utf-8

require "sinatra/base"
require "sinatra/namespace"
require "sinatra-health-check"
require "time"
require "stringex"
require "georuby"
require "geo_ruby/ewk" # lest the DB dump a 'uninitialized constant GeoRuby::SimpleFeatures::Geometry::HexEWKBParser' error.
require "active_support" # for the slug.
require "active_support/inflector"
require "active_support/core_ext/array/conversions"
require "jsonapi-serializers"

require_relative "./model"

class NYWalkerServer < Sinatra::Base
 
  use Rack::Session::Cookie, secret: ENV['COOKIE'], expire_after: 2592000

  if Sinatra::Base.development?
    set :session_secret, "supersecret"
  end
  base = File.dirname(__FILE__)
  set :root, base

  register Sinatra::Namespace

  # The API
  require "#{base}/app/routes/api"

  # The Rake methods that are also accessible from here.
  require "#{base}/app/rake-methods"

  # To get the API to work.
  require "#{base}/app/api"

end

