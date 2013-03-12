require 'action_controller/railtie'
require 'action_view/railtie'

# config
app = Class.new Rails::Application
app.config.active_support.deprecation = :log
app.initialize!

# routing
app.routes.draw do
  resources :users
end

# models
class User
end

# controllers
class ApplicationController < ActionController::Base;
  include Rescue::Controller
  define_errors ServerError: 500, NotFound: 404
end
class UsersController < ApplicationController
end

Object.const_set(:ApplicationHelper,Module.new)
