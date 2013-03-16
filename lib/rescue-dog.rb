require "rescue/version"

require File.join(File.dirname(__FILE__),'rescue/controller.rb')
module Rescue

  def define_error_class class_name, superclass = nil
    return if Object.const_defined?(class_name)
    Object.const_set(class_name, Class.new(superclass||StandardError))
  end

  module_function :define_error_class

end
