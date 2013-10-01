# coding: UTF-8
module Rescue
  module Controller
    class Flash

      def self.message object, key 
        scope = "views.#{object.controller_path.gsub(%r{/}, '.')}.#{object.action_name}.flash"
        text(key, scope)
      end

      # Private Methods
      def self.default key
        s = I18n.t("default.flash.#{key}", default: '')
        s.blank? ? nil : s
      end

      def self.text key, scope
        s = I18n.t("#{scope}.#{key}", default: '')
        s.blank? ? default(key) : s
      end
      private_class_method :default, :text
    end
  end
end
