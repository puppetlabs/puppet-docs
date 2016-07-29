module Jekyll
  module Tags
    class MarkdownBlock < Liquid::Block
      include Liquid::StandardFilters

      def initialize(tag_name, markup, tokens)
        super
        @prefix = ""
        @suffix = ""
      end

      def render(context)
        md_converter = context.registers[:site].converters.select {|c| c.matches('.md')}.first
          # Found that bit via Jekyll::Renderer's converters method.
        block_contents = super.to_s
          # IDK why you'd need to_s on a string, but the highlight tag does it, so we will too.

        output = md_converter.convert(block_contents)
        @prefix + output + @suffix
      end
    end

  end
end

Liquid::Template.register_tag('md', Jekyll::Tags::MarkdownBlock)
