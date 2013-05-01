require 'active_support/configurable'

module Rescue

  def self.configure(&block)
    yield @config ||= Rescue::Configuration.new
  end

  def self.config
    @config
  end

  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :respond_name
    config_accessor :suppress_response_codes

    def param_name
      config.param_name.respond_to?(:call) ? config.param_name.call : config.param_name
    end

    # define param_name writer (copied from AS::Configurable)
    writer, line = 'def param_name=(value); config.param_name = value; end', __LINE__
    singleton_class.class_eval writer, __FILE__, line
    class_eval writer, __FILE__, line
  end

  configure do |config|
    config.respond_name            = :respond_status
    config.suppress_response_codes = false
  end
end
