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

        # Defaults
        @@options[:styleblock_path]         ||= 'styleblocks'
        @@options[:custom_styleguide_block] ||= false
        @@options[:styleguide_block_file]   ||= '_styleguide_block.html.erb'

        app.send :include, Helpers
      end
      alias :included :registered
    end

    module Helpers
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
      def styleblock(tile, options = {})
        @block_html = self.styleblock_html(tile)
        @styleguide = self.parse_styleguide

        if options.has_key?(:section)
          self.render_rich_styleblock(options)
        else
          self.render_plain_styleblock
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

      protected

        # Render a rich styleblock using the styleguide block template
        def render_rich_styleblock(options)
          @section = @styleguide.section(options[:section])

          if @section.blank? or @section.description.blank?
            raise "Section must have a description. Section #{options[:section]} does not have one or section does not exist."
          end

          # Render the styleguide block
          template = ::Tilt.new(self.styleguide_block_path)
          template.render(self)
        end

        # Render the plain styleblock HTML
        def render_plain_styleblock
          @block_html.gsub('$modifier_class', '').gsub(' class=""', '').prepend('<div class="styleguide-styleblock">') << '</div>'
        end

        def parse_styleguide
          # Parse the KSS style guide once per request (because it probably changes every request)
          unless request.has_key?(:styleguide)
            kss_path = File.join(self.source_dir, self.extension_options[:kss_dir])
            request[:styleguide] = ::Kss::Parser.new(kss_path)
          end

          return request[:styleguide]
        end

        def styleblock_html(tile_name)
          tile_file = "_#{tile_name}.html.erb"
          tile_path = File.join(self.source_dir, self.extension_options[:styleblock_path], tile_file)
          ::Tilt.new(tile_path).render(self)
        end

        def styleguide_block_path
          if extension_options[:custom_styleguide_block]
            File.join(self.source_dir, self.extension_options[:styleguide_block_file])
          else
            File.join(File.dirname(__FILE__), self.extension_options[:styleguide_block_file])
          end
        end

        def extension_options
          ::Middleman::KSS.options
        end

    end
  end
end
