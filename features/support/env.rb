require 'capybara'
require 'capybara/cucumber'
require 'factory_girl/step_definitions'

require_relative "../../app"

Capybara.app = App
