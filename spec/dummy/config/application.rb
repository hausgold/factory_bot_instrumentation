# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'factory_bot_instrumentation'

module Dummy
  class Application < Rails::Application
  end
end
