require 'action_controller/railtie'
require 'action_view/railtie'

# const
STATUSES = {
  :bad_request  => 400,
  :unauthorized => 401,
  :not_found    => 404,
  :server_error => 500,
}

# dummy module
module ActiveRecord
  class RecordNotFound < StandardError ; end
end
module Mongoid
  module Errors
    class DocumentNotFound < StandardError ; end
  end
end
module BSON
  class InvalidObjectId < RuntimeError ; end
end

# config
Rescue.configure do |config|
  config.suppress_response_codes = true
end

app = Class.new Rails::Application
app.config.active_support.deprecation = :log
app.config.secret_token = 'ccedfce890492dd9fe2908a69a8732104ae133f1e2488bf6a1e96685b05a96d7e11aeaa3da5ade27604a50c3b2c7cc8323dd03ad11bb2e52e95256fb67ef9c8a'
app.config.generators do |g|
  g.template_engine :haml
end
app.initialize!

# routing
app.routes.draw do
  STATUSES.each do |name, code|
    get "/static/#{name}"  =>"static##{name}"  ,as: "static_#{name}"
    get "/dynamic/#{name}" =>"dynamic##{name}" ,as: "dynamic_#{name}"
  end

  Rescue::ApplicationError::STATUS_CODES.each do |code, e|
    get "/status/#{code}" =>"status#error_#{code}" ,as: "status_#{code}"
  end
end

# controllers
class ApplicationController < ActionController::Base ; end

class StaticController < ApplicationController
  include Rescue::Controller::Static
  rescue_associate :BadRequest   ,with: 400
  rescue_associate :Unauthorized ,with: 401
  rescue_associate :NotFound, Mongoid::Errors::DocumentNotFound, BSON::InvalidObjectId, with: 404
  rescue_associate :ServerError  ,with: 500

  STATUSES.each do |name, code|
    class_name = "#{name}".classify
    define_method name do
      raise class_name.constantize
    end
  end
end

class DynamicController < ApplicationController
  include Rescue::Controller::Dynamic
  rescue_associate :BadRequest   ,with: 400
  rescue_associate :Unauthorized ,with: 401
  rescue_associate :NotFound, ActiveRecord::RecordNotFound, with: 404
  rescue_associate :ServerError  ,with: 500

  STATUSES.each do |name, code|
    class_name = "#{name}".classify
    define_method name do
      raise class_name.constantize.new "This is an explanation of what caused the error."
    end
  end
end

class StatusController < ApplicationController
  include Rescue::Controller::Dynamic
  include Rescue::RespondError

  Rescue::ApplicationError::STATUS_CODES.each do |code, e|
    define_method "error_#{code}" do
      raise e[:status].gsub(' ', '').constantize.new "This is an explanation of what caused the error."
    end
  end
end

# models
class RescueModel
end

Object.const_set(:ApplicationHelper,Module.new)
