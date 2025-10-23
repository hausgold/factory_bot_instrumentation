# frozen_string_literal: true

module FactoryBot
  module Instrumentation
    # The configuration for the instrumentation API.
    class Configuration < ActiveSupport::OrderedOptions
      # Track our configurations settings (+Symbol+ keys) and their defaults as
      # lazy-loaded +Proc+'s values
      class_attribute :defaults,
                      instance_reader: true,
                      instance_writer: false,
                      instance_predicate: false,
                      default: {}

      # Create a new +Configuration+ instance with all settings populated with
      # their respective defaults.
      #
      # @param args [Hash{Symbol => Mixed}] additional settings which
      #   overwrite the defaults
      # @return [Configuration] the new configuration instance
      def initialize(**args)
        super()
        defaults.each { |key, default| self[key] = instance_exec(&default) }
        merge!(**args)
      end

      # A simple DSL method to define new configuration accessors/settings with
      # their defaults. The defaults can be retrieved with
      # +Configuration.defaults+ or +Configuration.new.defaults+.
      #
      # @param name [Symbol, String] the name of the configuration
      #   accessor/setting
      # @param default [Mixed, nil] a non-lazy-loaded static value, serving as
      #   a default value for the setting
      # @param block [Proc] when given, the default value will be lazy-loaded
      #   (result of the Proc)
      def self.config_accessor(name, default = nil, &block)
        # Save the given configuration accessor default value
        defaults[name.to_sym] = block || -> { default }

        # Compile reader/writer methods so we don't have to go through
        # +ActiveSupport::OrderedOptions#method_missing+.
        define_method(name) { self[name] }
        define_method("#{name}=") { |value| self[name] = value }
      end

      # The instrumentation configuration file path we should use,
      # defaults to config/instrumentation.yml
      config_accessor(:config_file) do
        'config/instrumentation.yml'
      end

      # You can set a fixed application name here,
      # defaults to your Rails application name in a titlized version
      config_accessor(:application_name) { nil }

      # By default we use the Rails default JSON rendering mechanism, but
      # you can configure your own logic here
      config_accessor(:render_entity) do
        proc do |controller, entity|
          controller.render plain: entity.to_json,
                            content_type: 'application/json'
        end
      end

      # By default we assemble a JSON response on errors which may be
      # helpful for debugging, but you can configure your own logic here
      config_accessor(:render_error) do
        proc do |controller, error|
          app_name = FactoryBot::Instrumentation.configuration.application_name
          controller.render status: :internal_server_error,
                            content_type: 'application/json',
                            plain: {
                              application: app_name,
                              error: error.message,
                              backtrace: error.backtrace.join("\n")
                            }.to_json
        end
      end

      # By default we do not perform any custom +before_action+ filters on the
      # instrumentation controllers, with this option you can implement your
      # custom logic like authentication
      config_accessor(:before_action) { nil }
    end
  end
end
