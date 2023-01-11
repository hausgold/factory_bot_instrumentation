# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
ENV['DISABLE_DATABASE_ENVIRONMENT_CHECK'] = '1'

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'countless/rake_tasks'

APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each { |f| load f }

desc 'Run all specs in spec directory (excluding plugin specs)'
RSpec::Core::RakeTask.new(spec: [
                            'db:drop', 'db:create', 'db:migrate', 'db:setup'
                          ])

task default: :spec

# Configure all code statistics directories
Countless.configure do |config|
  config.stats_base_directories = [
    { name: 'Top-levels', dir: 'lib',
      pattern: %r{/lib/[^/]+\.rb$} },
    { name: 'Top-levels specs', test: true, dir: 'spec',
      pattern: %r{/spec/[^/]+_spec\.rb$} },
    { name: 'Libraries',
      pattern: 'lib/factory_bot/**/*_spec.rb' },
    { name: 'Javascript', pattern: 'app/assets/**/*.js' },
    { name: 'Stylesheets', pattern: 'app/assets/**/*.css' },
    { name: 'Views', pattern: 'app/views/**/*.erb' },
    { name: 'Controllers', pattern: 'app/controllers/**/*.rb' },
    { name: 'Controllers specs', test: true,
      pattern: 'spec/controllers/**/*_spec.rb' }
  ]
end
