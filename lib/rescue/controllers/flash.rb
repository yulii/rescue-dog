# coding: UTF-8
module Rescue
  module Controller
    class Flash

      protected
      def self.message object, action, key 
        text(key, [:views, object.class.name.downcase, action, :flash])
      end

      private
      def self.default key
        s = I18n.t(key, scope: [:default, :flash], default: '')
        s.blank? ? nil : s
      end

      def self.text key, scope = []
        s = I18n.t(key, scope: scope, default: '')
        s.blank? ? default(key) : s
      end

    end
  end
end
