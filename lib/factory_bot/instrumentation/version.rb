# frozen_string_literal: true

module FactoryBot
  # The gem version details.
  module Instrumentation
    # The version of the +factory_bot_instrumentation+ gem
    VERSION = '1.7.1'

    class << self
      # Returns the version of gem as a string.
      #
      # @return [String] the gem version as string
      def version
        VERSION
      end

      # Returns the version of the gem as a +Gem::Version+.
      #
      # @return [Gem::Version] the gem version as object
      def gem_version
        Gem::Version.new VERSION
      end
    end
  end
end
