# coding: UTF-8
require File.join(File.dirname(__FILE__), "controller/static.rb")
require File.join(File.dirname(__FILE__), "controller/dynamic.rb")

module Rescue
  module Controller

    module ClassMethods

      def rescue_associate *klasses, &block
        options = klasses.extract_options!

        unless block_given?
          if options.has_key?(:with)
            if options[:with].is_a?(Integer)
              block = lambda {|e| send(Rescue::Bind.respond_name, options[:with], e) }
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
            Rescue::Bind.define_error_class klass, StandardError
            klass
          else
            raise ArgumentError, "#{klass} is neither an Exception nor a String"
          end
          self.rescue_handlers += [[key, block]]
        end
      end

    end
  end
end
