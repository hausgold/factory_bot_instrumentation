# frozen_string_literal: true

module FactoryBot
  module Instrumentation
    # A base engine application controller.
    class ApplicationController < ActionController::API
      # Extend our core functionality to support easy authentication logics
      include ActionController::HttpAuthentication::Basic::ControllerMethods
      include ActionController::HttpAuthentication::Digest::ControllerMethods
      include ActionController::HttpAuthentication::Token::ControllerMethods

      # For some reason the Rails engine may not find its partial templates as
      # it looks for wrong paths, so we add a fallback path to the view paths
      base_path = Pathname.new(File.expand_path('../../../views', __dir__))
      append_view_path base_path.join('factory_bot/instrumentation')

      # Allow the users to implement additional instrumentation-wide before
      # action logic, like authentication
      before_action do |_controller|
        if FactoryBot::Instrumentation.configuration.before_action
          instance_eval(
            &FactoryBot::Instrumentation.configuration.before_action
          )
        end
      end

      protected

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
    end
  end
end
