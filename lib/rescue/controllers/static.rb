# coding: UTF-8

module Rescue
  module Controller
    module Static

      def self.included(base)
        base.class_eval do
          define_method Rescue.config.respond_name do |code, exception = nil|
            render status: code, file: "#{Rails.root}/public/#{code}", layout: false and return
          end
        end
        base.send(:include, Rescue::Controller)
      end
  
    end
  end
end
