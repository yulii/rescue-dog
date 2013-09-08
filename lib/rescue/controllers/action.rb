# coding: UTF-8
module Rescue
  module Controller
    class Action

      protected
      def self.define object, method_name, type, clazz, var_sym, params_sym, options
        options ||= {}
        call_name   = :"#{type}_call"

        define_call(object, type, call_name, clazz, var_sym, params_sym)
        object.define_action_method(method_name, call_name, options)
      end

      private
      def self.define_call object, type, call_name, clazz, var_sym, params_sym
        return if object.method_defined? call_name
        case type
        when :new
          object.send(:define_method, call_name) do
            instance_variable_set(var_sym, clazz.new)
          end
        when :find
          object.send(:define_method, call_name) do
            id = find_params[Rescue.config.primary_key]
            instance_variable_set(var_sym, clazz.find(id))
          end
        when :create
          object.send(:define_method, call_name) do
            instance_variable_set(var_sym, clazz.new(send(params_sym)))
            instance_variable_get(var_sym).save!
          end
        when :update
          object.send(:define_method, call_name) do
            find_call
            instance_variable_get(var_sym).attributes = send(params_sym)
            instance_variable_get(var_sym).save!
          end
        when :delete
          object.send(:define_method, call_name) do
            find_call
            instance_variable_get(var_sym).destroy!
          end
        else
          return
        end
        object.send(:private, call_name)
      end

    end
  end
end
