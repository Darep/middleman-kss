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
      # @param [String] name
      #   Name of the styleblock file to render.
      # @param [Hash] options
      #   Options for rendering.
      # @option options [String] :section
      #   KSS section number (e.g. "1.1") for fetching the styleguide information.
      #
      # @return [String] Generated HTML.
      def styleblock(name, options = {})
        @styleguide = self.parse_styleguide
        @block_html = self.render_styleblock(name)

        if options.has_key?(:section)
          @section = @styleguide.section(options[:section])
          self.render_rich_styleblock(name, options)
        else
          self.render_plain_styleblock(name)
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

        def parse_styleguide
          # Parse the KSS style guide once per request (because it probably changes every request)
          unless request.has_key?(:styleguide)
            kss_path = File.join(self.source_dir, self.extension_options[:kss_dir])
            request[:styleguide] = ::Kss::Parser.new(kss_path)
          end

          return request[:styleguide]
        end

        # Render a rich styleblock using the styleguide block template
        def render_rich_styleblock(name, options)
          if @section.blank? or @section.description.blank?
            raise "Section must have a description. Section #{options[:section]} does not have one or section does not exist."
          end

          # Render the styleguide block
          ::Tilt.new(self.styleguide_block_path).render(self)
        end

        # Render the plain styleblock HTML
        def render_plain_styleblock(name)
          @block_html.gsub('$modifier_class', '').gsub(' class=""', '').prepend('<div class="styleguide-styleblock">') << '</div>'
        end

        def render_styleblock(name)
          ::Tilt.new(styleblock_path(name)).render(self)
        end

        def styleblock_path(name)
          File.join(self.source_dir, self.extension_options[:styleblock_path], "_#{name}.html.erb")
        end

        def styleguide_block_path
          base_path = extension_options[:custom_styleguide_block] ? self.source_dir : File.dirname(__FILE__)
          File.join(base_path, self.extension_options[:styleguide_block_file])
        end

        def extension_options
          ::Middleman::KSS.options
        end

    end
  end
end
