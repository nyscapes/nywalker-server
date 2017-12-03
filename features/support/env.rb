require 'simplecov'
require 'cucumber/rspec/doubles'
require 'capybara'
require 'capybara/cucumber'
require 'factory_bot'
require 'faker'

require_relative "../../app"

Capybara.app = App

World(FactoryBot::Syntax::Methods)
FactoryBot.find_definitions
