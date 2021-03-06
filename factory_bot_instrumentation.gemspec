# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'factory_bot/instrumentation/version'

Gem::Specification.new do |spec|
  spec.name          = 'factory_bot_instrumentation'
  spec.version       = FactoryBot::Instrumentation::VERSION
  spec.authors       = ['Hermann Mayer']
  spec.email         = ['hermann.mayer92@gmail.com']

  spec.summary       = 'Allow your testers to generate test data on demand'
  spec.description   = 'Allow your testers to generate test data on demand'
  spec.homepage      = 'https://github.com/hausgold/factory_bot_instrumentation'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'factory_bot'
  spec.add_runtime_dependency 'rails', '>= 5.0'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'bundler', '>= 1.16', '< 3'
  spec.add_development_dependency 'railties', '>= 4.2.0', '< 6.1'
  spec.add_development_dependency 'rspec-rails', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.63.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.31'
  spec.add_development_dependency 'simplecov', '< 0.18'
  spec.add_development_dependency 'sqlite3', '~> 1.3.6'
  spec.add_development_dependency 'timecop', '~> 0.9.1'
  spec.add_development_dependency 'yard', '~> 0.9.18'
  spec.add_development_dependency 'yard-activesupport-concern', '~> 0.0.1'
end
