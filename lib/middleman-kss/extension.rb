require 'kss'

begin
  require 'redcarpet'
rescue LoadError
end

begin
  require 'kramdown'
rescue LoadError
end

module Middleman
  module KSS
    class << self

      def options
        @@options
      end

      def registered(app, options_hash={})
        @@options = options_hash
        yield @@options if block_given?

        app.send :include, Helpers
      end
      alias :included :registered
    end

    module Helpers
      DEFAULT_STYLEGUIDE_BLOCK_FILE = '_styleguide_block.html.erb'

      # Renders a styleblock with or without styleguide information.
      #
      # @param [String] tile
      #   Name of the style tile file to render.
      # @param [Hash] options
      #   Options for rendering.
      # @option options [String] :section
      #   KSS section number (e.g. "1.1") for fetching the styleguide information.
      #
      # @return [String] Generated HTML.
      #
      def styleblock(tile, options = {})
        extension_options = ::Middleman::KSS.options

        # Parse the KSS style guide once per request (because it might change a lot, yo)
        unless request.has_key?(:styleguide)
          request[:styleguide] = ::Kss::Parser.new(File.join(self.source_dir, extension_options[:kss_dir]))
        end

        @styleguide = request[:styleguide]

        tile_file = "_#{tile}.html.erb"
        # TODO: remove "styleblocks" magic string
        tile_path = File.join(self.source_dir, "styleblocks", tile_file)

        # TODO: pass the file thru the rendering engines instead of just reading it
        @block_html = File.read(tile_path)

        if options.has_key?(:section)
          @section = @styleguide.section(options[:section])
          # TODO: remove magic strings: "partials" and "_styleguide_block.html.erb"
          styleguide_block_path = File.join(File.dirname(__FILE__), DEFAULT_STYLEGUIDE_BLOCK_FILE)
          render_individual_file(styleguide_block_path)
        else
          return @block_html.gsub('$modifier_class', '').gsub(' class=""', '')
          #render_individual_file(@block_html)
        end
      end

      # Simple HTML escape helper
      def kss_h(text)
        Rack::Utils.escape_html(text)
      end

      # Markdown in KSS
      def kss_markdown(input)
        markdown = ::Redcarpet::Markdown.new(::Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
        markdown.render(input)
      end

    end
  end
end
