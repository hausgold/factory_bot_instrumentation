# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

# When required on the specs, we load the rails binding
require 'factory_bot_rails' \
  if ENV.fetch('FACTORY_BOT_RAILS', 'false') == 'true'

require 'factory_bot_instrumentation'

module Dummy
  class Application < Rails::Application
  end
end
