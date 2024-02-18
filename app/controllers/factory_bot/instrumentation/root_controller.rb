# frozen_string_literal: true

module FactoryBot
  module Instrumentation
    # The Instrumentation engine controller with frontend and API actions.
    class RootController < ApplicationController
      # This is required to make API controllers template renderable
      include ActionView::Layouts

      # Configure the default application layout
      layout 'factory_bot/instrumentation/application'

      # Show the instrumentation frontend which features the output of
      # configured dynamic seeds scenarios. The frontend allows humans to
      # generate new seed data on the fly.
      def index
        @instrumentation = instrumentation
        @scenarios = scenarios
        @config = FactoryBot::Instrumentation.configuration
        render :index, layout: true
      end

      # Create a new entity with the given factory settings to create on demand
      # dependencies for your testing needs. You can pass in requests without
      # authentication in the following JSON format:
      #
      #   {
      #     "factory": "user",
      #     "traits": ["confirmed"],
      #     "overwrite": {
      #       "first_name": "Bernd",
      #       "last_name": "Schulze",
      #       "email": "bernd.schulze@example.com",
      #       "password": "secret"
      #     }
      #   }
      #
      # The result is the API v1 representation of the created entity.
      def create
        # Reload the factories to improve the test development experience.
        # In parallel request conditions this may lead to +Factory already
        # registered+ errors as this call is not thread safe as it seems,
        # so we retry it multiple times.
        with_retries(max_tries: 15) { FactoryBot.reload }
        # Call the factory construction with the user given parameters
        entity = FactoryBot.create(*factory_params)
        # Render the resulting entity with the configured rendering block
        FactoryBot::Instrumentation.configuration.render_entity.call(
          self, entity
        )
      rescue StandardError => e
        # Handle any error gracefully with the configured error handler
        FactoryBot::Instrumentation.configuration.render_error.call(self, e)
      end

      protected

      # Parse the given parameters from the request and build
      # a valid FactoryBot options set.
      #
      # @return [Array<Mixed>] the FactoryBot options
      #
      # rubocop:disable Metrics/MethodLength because of the Rails
      #   version handling
      def factory_params
        data = params.permit(:factory, traits: [])

        overwrite = if Rails::VERSION::MAJOR >= 5
                      params.to_unsafe_h.fetch(:overwrite, {})
                            .deep_symbolize_keys
                    else
                      params.fetch('overwrite', {}).deep_symbolize_keys
                    end

        [
          data.fetch(:factory).to_sym,
          *data.fetch(:traits, []).map(&:to_sym),
          { **overwrite }
        ]
      end
      # rubocop:enable Metrics/MethodLength

      # Unfortunately +Rails.configuration.instrumentation+ is only read once
      # and do not hot-reload on changes. Thats why we read this file manually
      # to get always a fresh state.
      #
      # @return [Hash{String => Mixed}] the instrumentation scenarios
      def instrumentation
        config_file = FactoryBot::Instrumentation.configuration.config_file.to_s
        template = ERB.new(Pathname.new(config_file).read)
        load_method = YAML.respond_to?(:unsafe_load) ? :unsafe_load : :load
        YAML.send(load_method, template.result(binding))[Rails.env] || {}
      end

      # Map all the instrumentation scenarios into groups and pass them back.
      #
      # @return [Hash{String => Array}] the grouped scenarios
      def scenarios
        res = (instrumentation['scenarios'] || [])
        res.each_with_object({}) do |scenario, memo|
          group = scenario_group(scenario['name'])
          scenario['group'] = group
          memo[group] = [] unless memo.key? group
          memo[group] << scenario
        end
      end

      # Map all the configured scenario groups to a useable hash.
      #
      # @return [Hash{Regexp => String}] the group mapping
      def groups
        (instrumentation['groups'] || {}).transform_keys do |key|
          Regexp.new(Regexp.quote(key))
        end
      end

      # Fetch the group name for a given scenario name. This will utilize the
      # +SCENARIO_GROUPS+ map.
      #
      # @param name [String] the scenario name
      # @return [String] the group name
      def scenario_group(name)
        groups.map do |pattern, group_name|
          next unless pattern.match? name

          group_name
        end.compact.first || 'Various'
      end
    end
  end
end
