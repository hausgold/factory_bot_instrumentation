# frozen_string_literal: true

module FactoryBot
  module Instrumentation
    # A tiny, dependency-free replacement for Sprockets' +require_tree+
    # directive. It concatenates the JavaScript or CSS sources shipped
    # with this engine into a single +application.{js,css}+ asset so
    # that the engine no longer needs an asset pipeline at runtime.
    #
    # The bundles are regenerated in two situations:
    #
    # * During gem release, via the +bundle_assets+ Rake task which is
    #   hooked into +rake build+.
    # * On +gem install+ / +bundle install+ (including Git source installs
    #   in third-party applications), via the RubyGems extension shim at
    #   +ext/factory_bot_instrumentation/extconf.rb+.
    module AssetBundler
      module_function

      # Absolute path to the gem root (where the +app+ and +lib+ folders
      # live), derived from this file's location.
      ROOT_DIR = File.expand_path('../../..', __dir__)

      # Per-kind configuration. Each entry describes where the sources
      # live, which extension to bundle, where to write the manifest and
      # how to format the comments wrapping each chunk.
      KINDS = {
        js: {
          source_dir: File.join(
            ROOT_DIR, 'app', 'assets', 'javascripts',
            'factory_bot_instrumentation'
          ),
          output_name: 'application.js',
          extension: 'js',
          line_comment: '// %s',
          banner_format: :line
        },
        css: {
          source_dir: File.join(
            ROOT_DIR, 'app', 'assets', 'stylesheets',
            'factory_bot_instrumentation'
          ),
          output_name: 'application.css',
          extension: 'css',
          line_comment: '/* %s */',
          banner_format: :block
        }
      }.freeze

      # Plain-text banner content, formatted per kind by +banner+. The
      # +%<kind>s+ and +%<source_rel>s+ placeholders are interpolated at
      # render time via +format+.
      BANNER_TEMPLATE = <<~TEXT
        !!! AUTO-GENERATED FILE - DO NOT EDIT !!!

        This file bundles every %<kind>s source under
        +%<source_rel>s/+ into a single asset. It is regenerated:
          * on `gem install` / `bundle install` (via a RubyGems extension
            hook), and
          * during gem release (via the `bundle_assets` Rake task).

        To rebuild it manually, run:

          $ bundle exec rake bundle_assets
      TEXT

      # All asset kinds known to the bundler.
      #
      # @return [Array<Symbol>] the registered kind identifiers
      def kinds
        KINDS.keys
      end

      # Build the bundle for the given +kind+ and write it to the
      # corresponding manifest. The manifest itself is excluded from the
      # input set so that re-runs are idempotent.
      #
      # @param kind [Symbol] one of +:js+ or +:css+
      # @return [Array<String>] absolute paths of the source files that
      #   were concatenated, in the order they appear in the output
      # @raise [ArgumentError] if +kind+ is not a known asset kind
      def bundle!(kind)
        conf = config(kind)
        files = sources(kind)
        File.write(
          File.join(conf[:source_dir], conf[:output_name]),
          banner(kind) + files.map { |f| chunk(kind, f) }.join
        )
        files
      end

      # Build every known asset kind in turn.
      #
      # @return [Hash{Symbol => Array<String>}] a mapping of kind to the
      #   absolute paths of the source files that were concatenated for
      #   that kind
      #
      # rubocop:disable Rails/IndexWith -- because we're
      #   dependency-free in here
      def bundle_all!
        kinds.to_h { |kind| [kind, bundle!(kind)] }
      end
      # rubocop:enable Rails/IndexWith

      # All sources to include for +kind+, sorted so the result is
      # stable across platforms and filesystems. The manifest itself is
      # excluded to avoid recursive inclusion.
      #
      # @param kind [Symbol] one of +:js+ or +:css+
      # @return [Array<String>] absolute paths of the matching source
      #   files, sorted ascending
      # @raise [ArgumentError] if +kind+ is not a known asset kind
      def sources(kind)
        conf = config(kind)
        output = File.expand_path(File.join(conf[:source_dir],
                                            conf[:output_name]))
        Dir.glob(File.join(conf[:source_dir], '**', "*.#{conf[:extension]}"))
           .reject { |path| File.expand_path(path) == output }
           .sort
      end

      # Look up the configuration for +kind+, raising on unknown values.
      #
      # @param kind [Symbol] the kind identifier to look up
      # @return [Hash] the configuration entry from +KINDS+, with keys
      #   +:source_dir+, +:output_name+, +:extension+, +:line_comment+
      #   and +:banner_format+
      # @raise [ArgumentError] if +kind+ is not a known asset kind
      def config(kind)
        KINDS.fetch(kind) do
          raise ArgumentError,
                "Unknown asset kind #{kind.inspect}; expected one of " \
                "#{KINDS.keys.inspect}"
        end
      end

      # Path of +file+ relative to its kind's source directory, used in
      # the per-chunk comment marker so the bundled output remains
      # debuggable.
      #
      # @param kind [Symbol] one of +:js+ or +:css+
      # @param file [String] the absolute path of a source file
      # @return [String] +file+ stripped of the kind's source directory
      #   prefix
      def relative_source(kind, file)
        file.sub("#{config(kind)[:source_dir]}/", '')
      end

      # Wrap a single source file with a comment that names its relative
      # path. The returned snippet starts with a newline so that chunks
      # concatenate cleanly under the banner.
      #
      # @param kind [Symbol] one of +:js+ or +:css+
      # @param path [String] the absolute path of the source file to
      #   wrap
      # @return [String] the comment-wrapped source contents
      def chunk(kind, path)
        conf = config(kind)
        body = File.read(path)
        body += "\n" unless body.end_with?("\n")
        marker = format(conf[:line_comment],
                        ">>> #{relative_source(kind, path)}")
        "\n#{marker}\n#{body}"
      end

      # Render the auto-generation banner in the comment style of +kind+.
      # JavaScript bundles get line comments (+// ...+), CSS bundles get
      # a single block comment (+/* ... */+).
      #
      # @param kind [Symbol] one of +:js+ or +:css+
      # @return [String] the banner ready to be prepended to the bundle,
      #   including the trailing newline
      def banner(kind)
        conf = config(kind)
        text = format(
          BANNER_TEMPLATE,
          kind: conf[:extension].upcase,
          source_rel: conf[:source_dir].sub("#{ROOT_DIR}/", '')
        )

        case conf[:banner_format]
        when :line
          lines = text.each_line
                      .map { |l| format(conf[:line_comment], l.chomp).rstrip }
                      .join("\n")
          "#{lines}\n"
        when :block
          body = text.each_line.map { |l| " * #{l.chomp}".rstrip }.join("\n")
          "/*\n#{body}\n */\n"
        end
      end
    end
  end
end
