# coding: UTF-8
module Rescue
  module Controller
    class Action

      def self.define object, clazz, var_sym, params_sym
        object.send(:define_method, :new_call) do
          instance_variable_set(var_sym, clazz.new)
        end
        object.send(:define_method, :find_call) do
          id   = find_params[Rescue.config.primary_key]
          instance_variable_set(var_sym, clazz.find(id))
        end
        object.send(:define_method, :create_call) do |&block|
          instance_variable_set(var_sym, clazz.new(send(params_sym)))
          instance_exec(&block) if block
          instance_variable_get(var_sym).save!
        end
        object.send(:define_method, :update_call) do |&block|
          find_call
          instance_variable_get(var_sym).attributes = send(params_sym)
          instance_exec(&block) if block
          instance_variable_get(var_sym).save!
        end
        object.send(:define_method, :delete_call) do |&block|
          find_call
          instance_exec(&block) if block
          instance_variable_get(var_sym).destroy!
        end
        object.send(:private, :new_call, :find_call, :create_call, :update_call, :delete_call)
      end

    end
  end
end
