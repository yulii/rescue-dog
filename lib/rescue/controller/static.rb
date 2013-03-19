# coding: UTF-8

module Rescue
  module Controller
    module Static
      def self.included(base)
        base.extend ClassMethods
        base.extend Rescue::Controller::ClassMethods
      end
  
      module ClassMethods
  
        def define_respond_method name
          return if method_defined?(name)
          define_method name do |code, exception = nil|
            render status: code, file: "#{Rails.root}/public/#{code}", layout: false and return
          end
        end

      end
    end
  end
end
