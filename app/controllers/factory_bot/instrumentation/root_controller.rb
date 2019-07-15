# frozen_string_literal: true

module FactoryBot::Instrumentation
  # The Instrumentation engine controller with frontend and API actions.
  class RootController < ApplicationController
    # This is required to make API controllers template renderable
    include ActionView::Layouts

    # Configure the default application layout
    layout 'factory_bot/instrumentation/application'

    # Show the instrumentation frontend which features the output of configured
    # dynamic seeds scenarios. The frontend allows humans to generate new seed
    # data on the fly.
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
    #       "last_name": "Müller",
    #       "email": "bernd.mueller@example.com",
    #       "password": "secret"
    #     }
    #   }
    #
    # The result is the API v1 representation of the created entity.
    def create
      # Reload the factories to improve the test development experience
      FactoryBot.reload
      # Call the factory construction with the user given parameters
      entity = FactoryBot.create(*factory_params)
      # Render the resulting entity as an API v1 representation
      render plain: entity.to_json, content_type: 'application/json'
    rescue StandardError => err
      # Log for local factory debugging and re-raise for canary onwards
      Rails.logger.error("#{err}\n#{err.backtrace.join("\n")}")
      raise err
    end

    private

    # Parse the given parameters from the request and build
    # a valid FactoryBot options set.
    #
    # @return [Array<Mixed>] the FactoryBot options
    def factory_params
      data = params.permit(:factory, traits: [])

      if Rails::VERSION::MAJOR >= 5
        overwrite = params.to_unsafe_h.fetch(:overwrite, {})
                          .deep_symbolize_keys
      else
        overwrite = params.fetch('overwrite', {}).deep_symbolize_keys
      end

      [
        data.fetch(:factory).to_sym,
        *data.fetch(:traits, []).map(&:to_sym),
        **overwrite
      ]
    end

    # Unfortunately +Rails.configuration.instrumentation+ is only read once and
    # do not hot-reload on changes. Thats why we read this file manually to get
    # always a fresh state.
    #
    # @return [Hash{String => Mixed}] the instrumentation scenarios
    def instrumentation
      config_file = FactoryBot::Instrumentation.configuration.config_file.to_s
      content = Pathname.new(config_file).read
      template = ERB.new(content)
      YAML.load(template.result(binding))[Rails.env]
    end

    # Map all the instrumentation scenarios into groups and pass them back.
    #
    # @return [Hash{String => Array}] the grouped scenarios
    def scenarios
      instrumentation['scenarios'].each_with_object({}) do |scenario, memo|
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
      instrumentation['groups'].each_with_object({}) do |(key, val), memo|
        memo[Regexp.new(Regexp.quote(key))] = val
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
