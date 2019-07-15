# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
ENV['DISABLE_DATABASE_ENVIRONMENT_CHECK'] = '1'

require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

APP_RAKEFILE = File.expand_path('../spec/dummy/Rakefile', __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }

require 'rspec/core'
require 'rspec/core/rake_task'

desc 'Run all specs in spec directory (excluding plugin specs)'
RSpec::Core::RakeTask.new(spec: [
  'db:drop', 'db:create', 'db:migrate', 'db:setup'
])

task default: :spec
