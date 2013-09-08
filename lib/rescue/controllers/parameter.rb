# coding: UTF-8
module Rescue
  module Controller
    class Parameter

      def self.define object
        id = Rescue.config.primary_key
        object.send(:define_method, :find_params) do
          params.require(id)
          params.permit(id)
        end
        object.send(:private, :find_params)
      end

    end
  end
end
