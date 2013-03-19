# coding: UTF-8

module Rescue
  module Controller
    module Dynamic
      def self.included(base)
        base.extend ClassMethods
        base.extend Rescue::Controller::ClassMethods
      end

      module ClassMethods
   
        def define_respond_method name
          return if method_defined?(name)
          define_method name do |code, exception = nil|
            e = {}
            e[:code]    = code
            e[:status]  = Rack::Utils::HTTP_STATUS_CODES[code]
            e[:message] = exception.message if exception

            respond_to do |format|
              format.html { render status: code, template: "/errors/#{code}" }
              format.json { render status: code, json: { errors: [e] } }
              format.xml  { render status: code, xml:  { errors: [e] } }
            end
          end
        end

      end
    end
  end
end
