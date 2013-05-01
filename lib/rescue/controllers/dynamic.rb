# coding: UTF-8

module Rescue
  module Controller
    module Dynamic

      def self.included(base)
        base.class_eval do
          define_method Rescue.config.respond_name do |code, exception = nil|
            e = {}
            if e.is_a? Rescue::ApplicationError
              e = { code: e.code, status: e.status, message: e.message }
            else
              e[:code]    = code
              e[:status]  = Rack::Utils::HTTP_STATUS_CODES[code]
              e[:message] = exception.message if exception
            end
  
            respond_to do |format|
              format.html { render status: code, template: "/errors/#{code}" }
              format.json { render status: code, json: { errors: [e] } }
              format.xml  { render status: code, xml:  { errors: [e] } }
            end
          end
        end
        base.extend Rescue::Controller::ClassMethods
      end

    end
  end
end
