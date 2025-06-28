# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'simplecov'
SimpleCov.command_name 'specs'

# Load the Rails dummy application
require 'bundler/setup'
require_relative 'dummy/config/environment'
require 'rspec/rails'
require 'factory_bot_instrumentation'
require 'timecop'

# Load all support helpers and shared examples
Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Enable the focus inclusion filter and run all when no filter is set
  # See: http://bit.ly/2TVkcIh
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end
