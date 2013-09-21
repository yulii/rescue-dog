# encoding: utf-8
require 'rubygems'
require 'rescue-dog'
require 'coveralls'

require File.join(File.dirname(__FILE__), 'fake_rails')
require File.join(File.dirname(__FILE__), 'test_case')
require 'capybara/rails'

#require 'benchmark'

Coveralls.wear!('rails')
RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec do |c|
    c.syntax = :expect    # disables `should`
  end
  config.include Capybara::DSL
end
