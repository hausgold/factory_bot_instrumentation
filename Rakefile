# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
ENV['DISABLE_DATABASE_ENVIRONMENT_CHECK'] = '1'

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'countless/rake_tasks'

APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'

desc 'Bundle the engine JavaScript and CSS sources into application.{js,css}'
task :bundle_assets do
  require 'factory_bot/instrumentation/asset_bundler'
  FactoryBot::Instrumentation::AssetBundler.bundle_all!.each do |kind, files|
    conf = FactoryBot::Instrumentation::AssetBundler.config(kind)
    rel = files.map { |f| f.sub("#{conf[:source_dir]}/", '') }
    puts "Bundled #{files.size} #{kind.upcase} source(s) into " \
         "#{conf[:output_name]}: #{rel.join(', ')}"
  end
end

# Ensure the asset bundles are up to date before we cut a release build.
# This guarantees that the +.gem+ file ships with freshly generated
# +application.js+ and +application.css+ manifests.
Rake::Task[:build].enhance([:bundle_assets]) \
  if Rake::Task.task_defined?(:build)

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
