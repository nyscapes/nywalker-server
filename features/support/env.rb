require 'capybara'
require 'capybara/cucumber'
require 'factory_bot'

require_relative "../../app"

Capybara.app = App
