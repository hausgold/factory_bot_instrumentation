# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'factory_bot/instrumentation/version'

Gem::Specification.new do |spec|
  spec.name = 'factory_bot_instrumentation'
  spec.version = FactoryBot::Instrumentation::VERSION
  spec.authors = ['Hermann Mayer']
  spec.email = ['hermann.mayer92@gmail.com']

  spec.license = 'MIT'
  spec.summary = 'Allow your testers to generate test data on demand'
  spec.description = 'Allow your testers to generate test data on demand'

  base_uri = "https://github.com/hausgold/#{spec.name}"
  spec.metadata = {
    'homepage_uri' => base_uri,
    'source_code_uri' => base_uri,
    'changelog_uri' => "#{base_uri}/blob/master/CHANGELOG.md",
    'bug_tracker_uri' => "#{base_uri}/issues",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{spec.name}"
  }

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5'

  spec.add_runtime_dependency 'factory_bot', '~> 6.2'
  spec.add_runtime_dependency 'rails', '>= 5.2'
  spec.add_runtime_dependency 'retries', '>= 0.0.5'

  spec.add_development_dependency 'appraisal', '~> 2.4'
  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'countless', '~> 1.1'
  spec.add_development_dependency 'factory_bot_rails', '~> 6.2'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'railties', '>= 5.2'
  spec.add_development_dependency 'rspec-rails', '~> 5.1'
  spec.add_development_dependency 'rubocop', '~> 1.28'
  spec.add_development_dependency 'rubocop-rails', '~> 2.14'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.10'
  spec.add_development_dependency 'simplecov', '>= 0.22'
  spec.add_development_dependency 'sqlite3', '~> 1.5'
  spec.add_development_dependency 'timecop', '>= 0.9.6'
  spec.add_development_dependency 'yard', '>= 0.9.28'
  spec.add_development_dependency 'yard-activesupport-concern', '>= 0.0.1'
end
