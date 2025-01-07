# frozen_string_literal: true

module FactoryBot
  module Instrumentation
    # A base engine application controller.
    class ApplicationController < ActionController::Base
      # Extend our core functionality to support easy authentication logics
      include ActionController::HttpAuthentication::Basic::ControllerMethods
      include ActionController::HttpAuthentication::Digest::ControllerMethods
      include ActionController::HttpAuthentication::Token::ControllerMethods

      # Rails 5.2 enabled CSRF protection by default, but this may be different
      # on the host application. Therefore we cannot blindly disable it via
      # +skip_forgery_protection+. We have to "enable" it for no routes, which
      # eventually disables it entirely for this engine.
      protect_from_forgery only: []

      # Allow the users to implement additional instrumentation-wide before
      # action logic, like authentication
      before_action do |_controller|
        if FactoryBot::Instrumentation.configuration.before_action
          instance_eval(
            &FactoryBot::Instrumentation.configuration.before_action
          )
        end
      end

      # A simple shortcut for Basic Auth on Rails 4.2+. Just configure the
      # username and password and you're ready to check the current request.
      #
      # @param username [String] the required user name
      # @param password [String] the required password of the user
      # @param realm [String] the authentication realm
      def basic_auth(username:, password:, realm: 'Instrumentation')
        authenticate_or_request_with_http_basic(realm) \
          do |given_name, given_password|
          ActiveSupport::SecurityUtils.secure_compare(given_name, username) &
            ActiveSupport::SecurityUtils.secure_compare(
              given_password, password
            )
        end
      end

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
        res = instrumentation['scenarios'] || []
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
