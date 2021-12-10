# frozen_string_literal: true

module FactoryBot
  module Instrumentation
    # The Instrumentation engine which can be mounted.
    class Engine < ::Rails::Engine
      isolate_namespace FactoryBot::Instrumentation

      # Fill in some dynamic settings (application related)
      initializer 'factory_bot_instrumentation.config' do
        # Ensure the FactoryBot gem loads its factories to ensure they are
        # also available in the rails console and other places in the app
        # and not only via instrumentation frontend.
        FactoryBot.reload

        FactoryBot::Instrumentation.configure do |conf|
          # Set the application name dynamically
          conf.application_name \
            ||= Rails.application.class.parent_name.titleize
        end
      end
    end
  end
end
