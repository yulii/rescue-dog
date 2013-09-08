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
        options = actions.extract_options!

        name = clazz.name.downcase
        var_sym    = :"@#{name}"
        params_sym = :"#{name}_params"

        Parameter.define(self)
 
        Action.define(self, :index, :index, clazz, var_sym, params_sym, options[:index])
        Action.define(self, :show, :find, clazz, var_sym, params_sym, options[:show])
        Action.define(self, :edit, :find, clazz, var_sym, params_sym, options[:edit])
        Action.define(self, :new, :new, clazz, var_sym, params_sym, options[:new])
        Action.define(self, :create, :create, clazz, var_sym, params_sym, options[:create])
        Action.define(self, :update, :update, clazz, var_sym, params_sym, options[:update])
        Action.define(self, :delete, :delete, clazz, var_sym, params_sym, options[:delete])
      end

      # TODO flash メッセージの構築ロジックを外出しに
      def define_action_method name, call_method, options = {}
        default_scope = [:default, :flash]
        success_message = options[:success] || I18n.t(:success ,scope: default_scope ,default: '')
        error_message   = options[:error]   || I18n.t(:error   ,scope: default_scope ,default: '')
        define_method name do
          begin
            send(call_method)
            flash[:success] = success_message unless success_message.blank?
            instance_exec(&options[:render]) if options[:render]
          rescue
            # TODO でバッグ用のエラーメッセージ出力ロジックは？？？
            flash.now[:error] = error_message unless error_message.blank?
            instance_exec(&options[:rescue]) if options[:rescue]
          end
        end
      end

    end
  end
end
