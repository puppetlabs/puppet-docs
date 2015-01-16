module Jekyll
  # We just need something quick and dirty, so I'm going to just copy and paste
  # from my old render_nav plugin. MEH.

  # This tag takes no arguments and renders a fragment of arbitrary HTML from
  # the "version_note" key of a page's yaml frontmatter.

  # If the page doesn't have a specific version note, it will render the MOST
  # SPECIFIC fragment specified in the "version_notes" hash in _config.yml.
  # Which means you can do things like have a default fragment for /pe URLs,
  # but override it for /pe/2.5 URLs. The version_notes hash should look like this:

  # version_notes:
  #   /puppet/: "note for all Puppet versions"
  #   /puppet/3.7: "note for current version of Puppet"
  #   /puppetdb/master: "Note for master puppetdb"

  # Note that leaving / blank is fine.

  # -NF 2015
  class RenderVersionNoteTag < Liquid::Tag
    def initialize(tag_name, something_bogus, tokens)
      super
    end


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
      version_note = ''
      if context.environments.first['page']['version_note']
        version_note = context.environments.first['page']['version_note']
      else
        version_notes = context.environments.first['site']['version_notes']
        path = context.environments.first['page']['url']
        nearest_path = pick_best_default(path, version_notes.keys)
        version_note = version_notes[nearest_path]
      end

      version_note

      # If we ever need to render Liquid tags in the version note fragments, we can change the above line to this:

#       partial = Liquid::Template.parse(version_note)
#       context.stack do
#         partial.render(context)
#       end
    end

  end
end

Liquid::Template.register_tag('render_version_note', Jekyll::RenderVersionNoteTag)
