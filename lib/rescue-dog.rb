require "rescue/version"

require 'rescue/config.rb'
require 'rescue/controller.rb'
require "rescue/controller/static.rb"
require "rescue/controller/dynamic.rb"

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
