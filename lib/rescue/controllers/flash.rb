# coding: UTF-8
module Rescue
  module Controller
    class Flash

      def self.message object, action, key 
        controllers = object.class.name.gsub('Controller', '').split('::').map {|e| e.underscore }
        scope = ([:views] + controllers) << action << :flash
        text(key, scope)
      end

      def self.default key
        s = I18n.t(key, scope: [:default, :flash], default: '')
        s.blank? ? nil : s
      end

      def self.text key, scope = []
        s = I18n.t(key, scope: scope, default: '')
        s.blank? ? default(key) : s
      end
      private_class_method :default, :text
    end
  end
end
