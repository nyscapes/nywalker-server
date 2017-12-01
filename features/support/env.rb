require 'capybara'
require 'capybara/cucumber'

require_relative "../../app"

Capybara.app = App
