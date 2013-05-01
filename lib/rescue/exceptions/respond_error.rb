module Rescue
  module RespondError

    def self.included(base)
      Rescue::ApplicationError::STATUS_CODES.each do |code, e|
        status_code = (Rescue.config.suppress_response_codes ? 200 : e[:http])
        class_name = e[:status].gsub(' ', '')
        next if Object.const_defined?(class_name)

        exception_class = Class.new(Rescue::ApplicationError) do
          define_method :initialize do |message = nil|
            super code, e[:status], message
          end
        end
        Object.const_set class_name, exception_class
        base.rescue_associate class_name, with: status_code
      end
    end

  end
end
