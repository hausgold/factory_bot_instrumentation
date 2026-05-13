# frozen_string_literal: true

module FactoryBot
  module Instrumentation
    # The Instrumentation engine which can be mounted.
    class Engine < ::Rails::Engine
      isolate_namespace FactoryBot::Instrumentation
      engine_name 'factory_bot_instrumentation'

      # Fill in some dynamic settings (application related)
      initializer 'factory_bot_instrumentation.config' do |app|
        # Ensure the FactoryBot gem loads its factories to ensure they are also
        # available in the rails console and other places in the app and not
        # only via instrumentation frontend. We skip this step as in
        # combination with the +factory_bot_rails+ gem (>=6.0) the FactoryBot
        # initializing occurs after the Rails application initializing, which
        # leads to +FactoryBot::DuplicateDefinitionError+s.
        initializer_names = app.initializers.map(&:name).map(&:to_s)
        FactoryBot.reload \
          if initializer_names.grep(/^factory_bot\./).none?

        FactoryBot::Instrumentation.configure do |conf|
          # Set the application name dynamically
          conf.application_name ||= begin
            app_class = Rails.application.class
            parent_name = app_class.module_parent_name \
              if app_class.respond_to?(:module_parent_name)
            parent_name ||= app_class.parent_name
            parent_name.titleize
          end
        end
      end

      # For some reason the Rails engine may not find its partial templates
      # as it looks for wrong paths, so we add a fallback path to the view
      # paths
      app_path = Pathname.new(File.expand_path('../../../app', __dir__))
      paths['app/views'].push(
        app_path.join('views/factory_bot/instrumentation').to_s
      )

      # Register the engine's assets with the host application's Sprockets
      # precompile list so they are picked up by +rake assets:precompile+.
      # The Sprockets 4+ syntax expects bare logical paths, while older
      # versions need a +proc+ matcher - we handle both.
      initializer 'factory_bot_instrumentation.assets', group: :all do |app|
        if app.config.respond_to?(:assets) && defined?(Sprockets)
          sprockets_4_or_later =
            Gem::Version.new(Sprockets::VERSION) >= Gem::Version.new('4')

          %w[
            factory_bot_instrumentation/application.js
            factory_bot_instrumentation/application.css
          ].each do |asset_path|
            app.config.assets.precompile << (
              if sprockets_4_or_later
                asset_path
              else
                proc { |path| path == asset_path }
              end
            )
          end
        end
      end
    end
  end
end
