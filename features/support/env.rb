ENV['RACK_ENV'] = 'test'

require 'simplecov'
require 'cucumber/rspec/doubles'
require 'capybara'
require 'capybara/cucumber'
require 'factory_bot'
require 'faker'

require_relative "../../app"

Capybara.app = NYWalkerServer

World(FactoryBot::Syntax::Methods)
FactoryBot.find_definitions
