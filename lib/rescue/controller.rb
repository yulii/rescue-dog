# coding: UTF-8
module Rescue
  module Controller

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
        options    = actions.extract_options!
        name       = clazz.name.downcase
        var_sym    = :"@#{name}"
        params_sym = :"#{name}_params"

        Parameter.define(self)
        Action.define(self, clazz, var_sym, params_sym)

        [:new, :edit, :show, :create, :update, :delete].each do |type|
          args = options.delete(type) || (actions.delete(type) ? {} : nil)
          define_action_method(type, args) if args
        end
      end

      def define_action_method name, options = {}
        raise RuntimeError "`name` is already defined." if method_defined?(name)
        options[:type]  ||= name
        options[:flash] ||= [:create, :update, :delete].include?(options[:type])
        call_method = case options[:type]
          when :show, :edit ; :find_call
          else ; :"#{options[:type]}_call"
        end
        rescue_given    = options[:rescue]||options[:error]||options[:flash]
        success_message = options[:success]
        error_message   = options[:error]
        if options[:flash]
          success_message ||= Flash.message(self, name, :success)
          error_message   ||= Flash.message(self, name, :error)
        end

        if rescue_given
          define_method name do
            begin
              send(call_method, &options[:intercept])
              flash[:success] = success_message unless success_message.blank?
              instance_exec(&options[:render]) if options[:render]
            rescue => e
              Rails.logger.debug(e.backtrace.unshift(e.message).join("\n\t"))
              flash.now[:error] = error_message unless error_message.blank?
              instance_exec(&options[:rescue]) if options[:rescue]
            end
          end
        else
          define_method name do
            send(call_method)
            instance_exec(&options[:render]) if options[:render]
          end
        end
      end

    end
  end
end
