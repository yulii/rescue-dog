# coding: UTF-8
require File.join(File.dirname(__FILE__), "controller/static.rb")
require File.join(File.dirname(__FILE__), "controller/dynamic.rb")

module Rescue
  module Controller

    module ClassMethods

      def define_errors statuses, superclass = StandardError
        respond = :respond_status
        define_respond_method respond

        statuses.each do |class_name, code|
          Rescue::Bind.define_error_class class_name, superclass
          rescue_from "#{class_name}".constantize, with: lambda {|e| send(respond, code, e) }
        end
      end
    end

  end
end
