# coding: UTF-8
require File.join(File.dirname(__FILE__), "controller/static.rb")
require File.join(File.dirname(__FILE__), "controller/dynamic.rb")

module Rescue
  module Controller
    def self.included(base) ; base.extend ClassMethods ; end

    module ClassMethods
      def define_errors render, statuses, superclass = StandardError
        case render
        when :static  ; include Rescue::Controller::Static
        when :dynamic ; include Rescue::Controller::Dynamic
        else          ; raise NotImplementedError, "#{name} is undefined because invalid routes specified."
        end

        statuses.each do |class_name, code|
          respond = :"respond_#{code}"

          Rescue.define_error_class class_name, superclass

          define_respond_method respond, code
          rescue_from "#{class_name}".constantize, with: respond
        end
      end

    end

  end
end
