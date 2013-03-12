# coding: UTF-8
module Rescue
  module Controller

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def define_errors statuses, superclass = StandardError
        statuses.each do |class_name, code|
          respond = :"respond_#{code}"

          define_error_class class_name, superclass
          define_respond_method respond, code

          # an error maps to respond method
          rescue_from "#{class_name}".constantize, with: respond
        end
      end

      def define_error_class class_name, superclass = StandardError
        return if Object.const_defined?(class_name)
        Object.const_set(class_name, Class.new(superclass))
      end

      # Define "respond_#{code}" method
      def define_respond_method name, code
        return if method_defined?(name)
        define_method name do |e = nil|
          render status: code, file: "#{Rails.root}/public/#{code}.#{request.format.to_sym}", layout: false and return
        end
      end
    end

  end
end
