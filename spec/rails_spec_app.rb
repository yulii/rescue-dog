require 'action_controller/railtie'
require 'action_view/railtie'

# const
STATUSES = {
  :bad_request  => 400,
  :unauthorized => 401,
  :not_found    => 404,
  :server_error => 500,
}

# config
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
    get "/static/#{name}"  =>"static##{name}"  ,as: name
    get "/dynamic/#{name}" =>"dynamic##{name}" ,as: name
  end
end

# controllers
class ApplicationController < ActionController::Base ; end

class StaticController < ApplicationController
  include Rescue::Controller
  define_errors :static, BadRequest: 400, Unauthorized: 401, NotFound: 404, ServerError: 500

  STATUSES.each do |name, code|
    class_name = "#{name}".classify
    define_method name do
      raise class_name.constantize
    end
  end
end

class DynamicController < ApplicationController
  include Rescue::Controller
  define_errors :dynamic, BadRequest: 400, Unauthorized: 401, NotFound: 404, ServerError: 500

  STATUSES.each do |name, code|
    class_name = "#{name}".classify
    define_method name do
      raise class_name.constantize
    end
  end
end

Object.const_set(:ApplicationHelper,Module.new)
