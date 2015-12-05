source 'http://rubygems.org'

ruby '2.2.3'

### FUNDAMENTALS
# Sinatra, sinatrarb.com, is the web framework that makes the site run.
gem 'sinatra'

# Sinatra-support provides a set of extra helpers, but none are currently used.
gem 'sinatra-support', require: 'sinatra/support'

# Sinatra-assetpack serves up compressed/etc. assets (css/js/img). The github
# version is needed for `rake assetpack:precompile`, which compiles the assets
# into public/. Without this, AWS doesn't catch the assets, though Heroku does.
#
# VITAL: Elastic Beanstalk does not come with git preinstalled, which means
# this call to github will break the app, wasting a lot of your time. Be
# certain to preinstall git (`sudo yum install git`) after sshing into the
# instance (`eb ssh`, which will prompt for a setup).
#
# OTOH, the rake task is only necessary in development, because compressed
# assets are pushed to AWS, so balance needs accordingly.
gem 'sinatra-assetpack', require: 'sinatra/assetpack', 
  github: 'rstacruz/sinatra-assetpack'

# Sinatra-flash talks more smoothly to Rack::Flash to provide messages that go
# from one page to another, such as save confirmations or errors.
gem 'sinatra-flash'

# Mustache-sinatra provides the mustache templating engine 
gem 'mustache-sinatra'

### DATABASE handling
# DataMapper is the ORM used in this project
gem 'data_mapper'

# DataMapper assumes postgresql databases, because the end goal is still a
# postGIS db.
gem 'dm-postgres-adapter'

# Dm-validations provides for validations of the presence and type of different
# data forms.
gem 'dm-validations'

# Dotenv lets us pass in ENV['VARIABLE']s. This is vital for initializing the
# database, which relies on ENV['DATABASE_URL']
#
# This should probably be limited to :development.
gem 'dotenv'

### DEPLOYMENT
# Thin is a webserver. This may be superfluous.
gem 'thin'

# Shotgun allows for fast prototyping because the server forks itself with
# every request, meaning changes to the app are visible instantly.
gem 'shotgun'

# That said, puma is the webserver used in deployment on AWS.
gem 'puma'

# When using Elastic Load Balancing on AWS, we can make use of custom health
# checks. Hence this gem.
gem 'sinatra-health-check'

### CENTRAL, VITAL functionality, but...
# ActiveSupport includes the useful #to_sentence method, used to make a pretty,
# English sentence out of an Array.
gem 'activesupport'

# Warden controls user authentication.
gem 'warden'

# Googlebooks talks to the Googlebooks API when finding books by ISBN. As far
# as I know, no better repository of books with both an API and ISBNs exists.
gem 'googlebooks'

### TESTING
#
# For another day...
#
group :test, :development do
  gem 'foreman'
  gem 'rack-test', require: 'rack/test'
  gem 'rspec'
  gem 'dm-rspec'
  gem 'factory_girl'
  gem 'cucumber'
end

