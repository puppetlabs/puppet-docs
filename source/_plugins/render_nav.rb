module Jekyll
  # Call it version 2.
  # This is largely a rip of Jekyll's include tag. It takes no arguments and
  # renders the _includes fragment identified in the "nav" key of a page's yaml
  # frontmatter.
  
  # If the page doesn't have a specific nav fragment, it will render the MOST
  # SPECIFIC default fragment specified in the "defaultnav" hash in _config.yml.
  # Which means you can do things like have a default nav fragment for /pe URLs,
  # but override it for /pe/2.5 URLs. Defaultnav hash should look like this: 

  # defaultnav: 
  #   /: quick_nav.html
  #   /mcollective: mcollective_menu.html
  #   /pe/2.5: pe25.html
  #   /pe/2.0: pe_2.0_nav.markdown

  
  # This allows us to easily set a custom nav for a set of pages.
  # -NF 2012
	class RenderNavTag < Liquid::Tag
		def initialize(tag_name, something_bogus, tokens)
			super
		end
    
    def pick_best_default(path, defaults_array)
			best_match = ''
      # Pop through the whole path, so we get the most specific matching default nav snippet.
      path_array = path.split('/')
      while !path_array.empty?
        partial_path = path_array.join('/')
          partial_path = '/' if partial_path == '' # because join on a single-element array gets us the wrong thing
        if defaults_array.include?(partial_path)
          best_match = partial_path
          break
        end
        path_array.pop
      end
      best_match
    end
    
		def render(context)
			nav_fragment = ''
			if context.environments.first['page']['nav']
			  nav_fragment = context.environments.first['page']['nav']
			else
			  defaultnav = context.environments.first['site']['defaultnav']
			  defaultnav_keys = defaultnav.keys
			  path = context.environments.first['page']['url']
			  nearest_path = pick_best_default(path, defaultnav_keys)
			  nav_fragment = defaultnav[nearest_path]
			end

      if nav_fragment == ''
        return "Blank navigation filename! Something went wrong. Check the nav variable in this file, then check the defaultnav hash in _config.yml."
      end
      if nav_fragment !~ /^[a-zA-Z0-9_\/\.-]+$/ || nav_fragment =~ /\.\// || nav_fragment =~ /\/\./
        return "Include file name '#{nav_fragment}' contains invalid characters or sequences"
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
