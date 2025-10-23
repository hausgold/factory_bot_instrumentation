# frozen_string_literal: true

require 'zeitwerk'
require 'logger'
require 'active_support'
require 'active_support/concern'
require 'active_support/ordered_options'
require 'active_support/cache'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/class/attribute'
require 'active_support/time'
require 'active_support/time_with_zone'
require 'retries'
require 'factory_bot'

module FactoryBot
  # The top level namespace for the factory_bot_instrumentation gem.
  module Instrumentation
    # Setup a Zeitwerk autoloader instance and configure it
    loader = Zeitwerk::Loader.for_gem_extension(FactoryBot)

    # Finish the auto loader configuration
    loader.setup

    # Make sure to eager load all constants
    loader.eager_load

    class << self
      attr_writer :configuration

      # Retrieve the current configuration object.
      #
      # @return [Configuration]
      def configuration
        @configuration ||= Configuration.new
      end

      # Configure the concern by providing a block which takes
      # care of this task. Example:
      #
      #   FactoryBot::Instrumentation.configure do |conf|
      #     # conf.xyz = [..]
      #   end
      def configure
        yield(configuration)
      end

      # Reset the current configuration with the default one.
      def reset_configuration!
        self.configuration = Configuration.new
      end
    end
  end
end
