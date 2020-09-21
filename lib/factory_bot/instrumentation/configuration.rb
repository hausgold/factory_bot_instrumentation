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
