module Jekyll
  # Call it version 4.
  # This works a lot like Jekyll's include tag. It takes no arguments and
  # renders the fragment identified in the "nav" key of a page's yaml
  # frontmatter.

  # If the page doesn't have a specific nav fragment, it will render the MOST
  # SPECIFIC default fragment specified in the "defaultnav" hash in _config.yml.
  # Which means you can do things like have a default nav fragment for /pe URLs,
  # but override it for /pe/2.5 URLs. Defaultnav hash should look like this:

  # defaultnav:
  #   /: /_includes/quick_nav.html
  #   /mcollective: /_includes/mcollective_menu.html
  #   /pe/2.5: /_includes/pe25.html
  #   /pe/2.0: /_includes/pe_2.0_nav.markdown

  # New in version 4: You can put nav fragments anywhere in the source
  # directory. The cost is that you need to use the full path (with `/` mapped
  # to `source/`), but the benefit is that we can keep nav fragments next to the
  # content they govern.
  # -NF 2015
  class RenderNavTag < Liquid::Tag
    require 'pathname'

    def initialize(tag_name, something_bogus, tokens)
      super
    end

# Old kinda naïve implementation
#     def pick_best_default(path, defaults_array)
#       best_match = ''
#       # Pop through the whole path, so we get the most specific matching default nav snippet.
#       path_array = path.split('/')
#       while !path_array.empty?
#         partial_path = path_array.join('/')
#           partial_path = '/' if partial_path == '' # because join on a single-element array gets us the wrong thing
#         if defaults_array.include?(partial_path)
#           best_match = partial_path
#           break
#         end
#         path_array.pop
#       end
#       best_match
#     end

    # Given a path and an array of directory names, get the most specific directory that matches.
    # Can also handle partial names on the final directory segment.
    def pick_best_default(path, defaults_array)
      current_dir = path.rpartition('/')[0]
      if defaults_array.include?(current_dir)
        return current_dir
      else
        current_length = 0
        current_match = ''
        defaults_array.each do |partial_path|
          next if partial_path.length < current_length
          if current_dir =~ Regexp.new("^#{Regexp.escape(partial_path)}")
            current_length = partial_path.length
            current_match = partial_path
          end
        end
        return current_match
      end
    end

    def render(context)
      nav_fragment = ''
      if context.environments.first['page']['nav']
        nav_fragment = context.environments.first['page']['nav']
      else
        defaultnav = context.environments.first['site']['defaultnav']
        path = context.environments.first['page']['url']
        nearest_path = pick_best_default(path, defaultnav.keys)
        nav_fragment = defaultnav[nearest_path]
      end

      if nav_fragment == ''
        return "Blank navigation filename! Something went wrong. Check the nav variable in this file, then check the defaultnav hash in _config.yml."
      end

      requested_path = Pathname.new(nav_fragment)
      cwd            = Pathname.new(context.environments.first["page"]["url"]).parent
      sourcedir      = Pathname.new(context.registers[:site].source)
      root           = Pathname.new('/')

      absolute_url = cwd + requested_path # if it's already absolute, abs1 + abs2 = abs2.
      real_file = sourcedir + absolute_url.relative_path_from(root)

      source = real_file.read
      partial = Liquid::Template.parse(source)
      context.stack do
        partial.render(context)
      end

    end
  end
end

Liquid::Template.register_tag('render_nav', Jekyll::RenderNavTag)
