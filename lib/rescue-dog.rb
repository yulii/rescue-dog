require "rescue/version"

require File.join(File.dirname(__FILE__),'rescue/controller.rb')
module Rescue

  class Bind
    class << self

      def respond_name
        :respond_status
      end

      def define_error_class class_name, superclass = nil
        return if Object.const_defined?(class_name)
        Object.const_set(class_name, Class.new(superclass||StandardError))
      end

    end
  end
end
