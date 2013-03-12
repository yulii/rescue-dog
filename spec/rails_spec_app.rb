require 'action_controller/railtie'
require 'action_view/railtie'

# config
app = Class.new Rails::Application
app.config.active_support.deprecation = :log
app.config.secret_token = 'ccedfce890492dd9fe2908a69a8732104ae133f1e2488bf6a1e96685b05a96d7e11aeaa3da5ade27604a50c3b2c7cc8323dd03ad11bb2e52e95256fb67ef9c8a'
app.initialize!

# routing
app.routes.draw do
  [:not_found, :server_error].each do |e|
    get "/#{e}"=>"errors##{e}" ,as: e
  end
end

# controllers
class ApplicationController < ActionController::Base;
  include Rescue::Controller
  define_errors ServerError: 500, NotFound: 404
end
class ErrorsController < ApplicationController

  def not_found    ; raise NotFound    ; end
  def server_error ; raise ServerError ; end

end

Object.const_set(:ApplicationHelper,Module.new)
