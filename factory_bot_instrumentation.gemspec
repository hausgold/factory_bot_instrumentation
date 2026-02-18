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

  spec.required_ruby_version = '>= 3.3'

  spec.add_dependency 'factory_bot', '~> 6.2'
  spec.add_dependency 'logger', '~> 1.7'
  spec.add_dependency 'rails', '>= 8.0'
  spec.add_dependency 'retries', '>= 0.0.5'
  spec.add_dependency 'zeitwerk', '~> 2.6'
end
