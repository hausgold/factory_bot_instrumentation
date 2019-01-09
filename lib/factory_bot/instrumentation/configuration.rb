# frozen_string_literal: true

module FactoryBot
  module Instrumentation
    # The configuration for the instrumentation API.
    class Configuration
      include ActiveSupport::Configurable

      # The instrumentation configuration file path we should use,
      # defaults to config/instrumentation.yml
      config_accessor(:config_file) do
        'config/instrumentation.yml'
      end

      # You can set a fixed application name here,
      # defaults to your Rails application name in a titlized version
      config_accessor(:application_name) { nil }
    end
  end
end
