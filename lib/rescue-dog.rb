require 'rescue/config.rb'
require 'rescue/controller.rb'
require "rescue/controllers/static.rb"
require "rescue/controllers/dynamic.rb"
require "rescue/controllers/action.rb"
require "rescue/controllers/flash.rb"
require 'rescue/exceptions/application_error.rb'
require 'rescue/exceptions/respond_error.rb'
require 'rescue/errors.rb'

module Rescue
  class Bind
    class << self

      def define_error_class class_name, superclass = nil
        return if Object.const_defined?(class_name)
        Object.const_set(class_name, Class.new(superclass||StandardError))
      end

    end
  end
end
