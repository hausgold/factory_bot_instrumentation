# frozen_string_literal: true

module FactoryBot
  module Instrumentation
    # The Instrumentation engine controller with frontend and API actions.
    class RootController < FactoryBot::Instrumentation::ApplicationController
      # Disable Rails' parameter wrapping. For JSON requests it would nest
      # a copy of the request body under a +root+ key (derived from this
      # controller's name). There is no +Root+ model to map onto, so the
      # wrapper only duplicates the parameters and adds a spurious
      # "Unpermitted parameters: :root" log warning.
      wrap_parameters false

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

      # Parse the given parameters from the request and build
      # a valid FactoryBot options set.
      #
      # @return [Array<Mixed>] the FactoryBot options
      def factory_params
        # Read the open-ended +overwrite+ hash unfiltered, as its keys and
        # values are arbitrary and cannot be described with strong
        # parameters.
        overwrite = params.to_unsafe_h.fetch(:overwrite, {})
                          .deep_symbolize_keys
        # Strip +overwrite+ before permitting the rest, otherwise it would
        # be reported as a spurious "Unpermitted parameters: :overwrite"
        # log warning.
        data = params.except(:overwrite).permit(:factory, traits: [])

        [
          data.fetch(:factory).to_sym,
          *data.fetch(:traits, []).map(&:to_sym),
          { **overwrite }
        ]
      end
    end
  end
end
