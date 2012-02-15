module Jekyll
  # This is a direct rip of Jekyll's include tag. It takes no arguments and
  # renders the _includes fragment identified in the "nav" key of a page's yaml
  # frontmatter.
  
  # This allows us to easily set a custom nav for a set of pages.
  # -NF 2012
	class RenderNavTag < Liquid::Tag
		def initialize(tag_name, something_bogus, tokens)
			super
		end

		def render(context)
			nav_fragment = context.environments.first['page']['nav'] || context.environments.first['site']['nav']
      if nav_fragment !~ /^[a-zA-Z0-9_\/\.-]+$/ || nav_fragment =~ /\.\// || nav_fragment =~ /\/\./
        return "Include file '#{nav_fragment}' contains invalid characters or sequences"
      end

      Dir.chdir(File.join(context.registers[:site].source, '_includes')) do
        choices = Dir['**/*'].reject { |x| File.symlink?(x) }
        if choices.include?(nav_fragment)
          source = File.read(nav_fragment)
          partial = Liquid::Template.parse(source)
          context.stack do
            partial.render(context)
          end
        else
          "Included file '#{nav_fragment}' not found in _includes directory"
        end
      end
		end
	end
end

Liquid::Template.register_tag('render_nav', Jekyll::RenderNavTag)
