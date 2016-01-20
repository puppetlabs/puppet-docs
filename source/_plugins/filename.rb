# Written by Nick Fagerlund.
# Inserts the filename (sans parent directories) of the current page. This will mostly be useful for skipping to the exact equivalent page in a different version's manual.

module Jekyll
  class FileNameTag < Liquid::Tag
    def initialize(tag_name, something_bogus, tokens)
      super
    end

    def render(context)
      full_url = context.environments.first['page']['url']
      # The negative second argument to split handles the case where the URL ends in a slash (/).
      # "/references/3.0.latest/type.html".split('/', -1) -> ["", "references", "3.0.latest", "type.html"]
      # "/references/3.0.latest/".split('/', -1) -> ["", "references", "3.0.latest", ""]
      full_url.split('/', -1)[-1]
    end
  end
end

Liquid::Template.register_tag('filename', Jekyll::FileNameTag)
