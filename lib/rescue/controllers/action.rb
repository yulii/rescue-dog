# coding: UTF-8
module Rescue
  module Controller
    class Action

      def self.define_call object, clazz, var_sym
        object.send(:define_method, :new_call) do |params = {}|
          instance_variable_set(var_sym, clazz.new(params))
        end
# 検索条件を controller 毎に設定できるように
# Update/Delete の params 引数とは別管理
        object.send(:define_method, :find_call) do |params = {}|
          id = (params.empty? ? send(:params) : params).delete(Rescue.config.primary_key)
          instance_variable_set(var_sym, clazz.where(params).find(id))
        end
        object.send(:define_method, :create_call) do |params|
          new_call(params)
          instance_variable_get(var_sym).save!
        end
        object.send(:define_method, :update_call) do |params|
          find_call
          instance_variable_get(var_sym).attributes = params
          instance_variable_get(var_sym).save!
        end
        object.send(:define_method, :delete_call) do |params|
          find_call(params)
          instance_variable_get(var_sym).destroy!
        end
        object.send(:private, :new_call, :find_call, :create_call, :update_call, :delete_call)
      end

      def self.define object, names, args = {}
        names.each do |name|
          options = args[name]||{}
          type    = options[:type]||name
          raise RuntimeError "`name` is already defined." if object.private_method_defined?(name)
          case type
          when :show, :edit
            object.send(:define_method, name) do
              send(:find_call)
              instance_exec(&options[:render]) if options[:render]
            end
          when :new
            object.send(:define_method, name) do
              params = options[:params] ? send(options[:params]) : {}
              send(:new_call, params)
              instance_exec(&options[:render]) if options[:render]
            end
          when :create, :update, :delete
            object.send(:define_method, name) do
              params = send(options[:params])
              rescue_respond(:"#{type}_call", params, options)
            end
          else
            raise RuntimeError "Undefined action type `#{type}`."
          end
        end
      end

    end
  end
end
