# coding: UTF-8
module Rescue
  module Controller

    def self.included(base)
      base.extend Rescue::Controller::ClassMethods
      base.send(:private, :rescue_respond)
    end

    def rescue_respond call, params, options = {}
      begin
        send(call, params)
        success_message = options[:success]||Flash.message(self, :success)
        flash[:success] = success_message unless success_message.blank?
        instance_exec(&options[:render])
      rescue => e
        Rails.logger.debug ([e.message] + e.backtrace).join("\n\t")
        error_message = options[:error]||Flash.message(self, :error)
        flash.now[:error] = error_message unless error_message.blank?
        instance_exec(&options[:rescue])
      end
    end

    module ClassMethods

      def rescue_associate *klasses, &block
        options = klasses.extract_options!

        unless block_given?
          if options.has_key?(:with)
            if options[:with].is_a?(Integer)
              block = lambda {|e| send(Rescue.config.respond_name, options[:with], e) }
            elsif options[:with].is_a?(Proc)
              block = options[:with]
            end
          else
            raise ArgumentError, "Need a handler. Supply an options hash that has a :with key as the last argument."
          end
        end

        klasses.each do |klass|
          key = if klass.is_a?(Class) && klass <= Exception
            klass.name
          elsif klass.is_a?(String) || klass.is_a?(Symbol)
            if options.has_key?(:superclass)
              Rescue::Bind.define_error_class klass, options[:superclass]
            else
              Rescue::Bind.define_error_class klass, StandardError
            end
            klass
          else
            raise ArgumentError, "#{klass} is neither an Exception nor a String"
          end
          self.rescue_handlers += [[key, block]]
        end
      end

      def rescue_controller clazz, *actions
        options      = actions.extract_options!
        method_names = actions + options.keys
        name         = clazz.name.downcase

        [:show, :edit, :new].each do |type|
          (options.delete(type)||[]).each do |name|
            method_names << name
            options[name] = { type: type }
          end
        end

        [:create, :update, :destroy].each do |type|
          options[type] ||= {}
          options[type][:params] ||= :"#{type}_params"
        end

        Action.define_call(self, clazz, :"@#{name}")
        Action.define(self, method_names, options)
      end

    end
  end
end
