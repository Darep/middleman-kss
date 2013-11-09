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
        tile_file = "_#{tile}.html.erb"
        tile_path = File.join(self.source_dir, "styleblocks", tile_file)
        tile_template = ::Tilt.new(tile_path)

        @block_html = tile_template.render(self)
        @styleguide = self.get_styleguide

        if options.has_key?(:section)
          @section = @styleguide.section(options[:section])
          raise "Section must have a description. Section #{options[:section]} does not have one or section does not exist." if @section.description.blank?
        end

        if @section
          # Render the styleguide block
          styleguide_block_path = File.join(File.dirname(__FILE__), DEFAULT_STYLEGUIDE_BLOCK_FILE)
          template = ::Tilt.new(styleguide_block_path)
          return template.render(self)
        else
          # Render just the HTML without the $modifier_class thingies
          return @block_html.gsub('$modifier_class', '').gsub(' class=""', '').prepend('<div class="styleguide-styleblock">') << '</div>'
        end
      end

      # Simple HTML escape helper, used in the styleguide block template
      def kss_h(text)
        Rack::Utils.escape_html(text)
      end

      # KSS Markdown parser, used in the styleguide block template
      def kss_markdown(input)
        markdown = ::Redcarpet::Markdown.new(::Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
        markdown.render(input)
      end

      def get_styleguide
        # Parse the KSS style guide once per request (because it probably changes every request)
        unless request.has_key?(:styleguide)
          extension_options = ::Middleman::KSS.options
          request[:styleguide] = ::Kss::Parser.new(File.join(self.source_dir, extension_options[:kss_dir]))
        end

        return request[:styleguide]
      end

    end
  end
end
