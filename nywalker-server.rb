# frozen_string_literal: true
# encoding: utf-8
#
# NYWalker-Server is a Sinatra server that provides a public API for building
# datasets of novels and the places they mention. It allows for adding semantic
# information to each instance of a place mentioned.
#
# Author:: Moacir P. de Sá Pereira (http://moacir.com)
# GitHub:: https://github.com/nyscapes/nywalker-server
# Copyright:: © 2018, Moacir P. de Sá Pereira
# License:: Content and Data, CC-BY-SA. Code, GPLv3. See LICENSE and CONTENT_LICENSE for more information.

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

# This class inherits from Sinatra the dsl to run the server. Nearly every
# aspect of NYWalker-server falls under this class

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

