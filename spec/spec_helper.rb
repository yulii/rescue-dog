# encoding: utf-8
require 'rubygems'
require 'rescue-dog'

require File.join(File.dirname(__FILE__), 'rails_spec_app')
require File.join(File.dirname(__FILE__), 'test_case')
require 'capybara/rails'
RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec do |c|
    c.syntax = :expect    # disables `should`
  end
  config.include Capybara::DSL
end
