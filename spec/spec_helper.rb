# encoding: utf-8
require 'rubygems'
require 'rescue-dog'

require File.join(File.dirname(__FILE__), 'rails_spec_app')
require 'capybara/rails'
RSpec.configure do |config|
  config.mock_with :rspec
  config.include Capybara::DSL
end
