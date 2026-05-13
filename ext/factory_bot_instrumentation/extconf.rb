# frozen_string_literal: true

# This is a RubyGems "extension" shim. It is *not* a C extension; it is
# just the standard mechanism RubyGems offers to run arbitrary Ruby code
# at gem-install time. We use it to regenerate the JavaScript and CSS
# bundles of the engine so that downstream applications - including
# those that pin this gem from a Git branch via Bundler - always get
# up-to-date +application.js+ / +application.css+ manifests without
# needing Sprockets or any external tooling.
#
# RubyGems invokes this file with the current working directory set to
# this file's directory and then runs +make+ against the +Makefile+ we
# write below. Because the actual work is done here, the Makefile is a
# no-op.

require 'fileutils'

# The gem root sits two levels above this file
# (ext/factory_bot_instrumentation/extconf.rb -> gem root).
gem_root = File.expand_path('../..', __dir__)

# Load the bundler from the gem's own lib/ tree. We intentionally do not
# go through +require+ + $LOAD_PATH because at install time the gem is
# not yet activated.
require File.join(gem_root, 'lib', 'factory_bot', 'instrumentation',
                  'asset_bundler')

begin
  FactoryBot::Instrumentation::AssetBundler.bundle_all!.each do |kind, files|
    conf = FactoryBot::Instrumentation::AssetBundler.config(kind)
    warn "[factory_bot_instrumentation] Bundled #{files.size} " \
         "#{kind.upcase} source(s) into #{conf[:output_name]}"
  end
rescue StandardError => e
  # Never block the install on a bundling failure - the placeholder
  # manifests that ship in the gem are still valid (empty) assets. We
  # just print a warning so the user can investigate.
  warn '[factory_bot_instrumentation] Could not bundle assets: ' \
       "#{e.class}: #{e.message}"
end

# RubyGems expects +extconf.rb+ to produce a Makefile. Ours has nothing
# to compile, so we emit a trivial one that satisfies +make+, +make
# install+ and +make clean+ without doing anything.
File.write('Makefile', <<~MAKEFILE)
  all:
  \t@true

  install:
  \t@true

  clean:
  \t@true
MAKEFILE
