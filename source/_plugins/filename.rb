# Written by Nick Fagerlund.
# Inserts the filename (sans parent directories) of the current page. This will mostly be useful for skipping to the exact equivalent page in a different version's manual. 

module Jekyll
  class FileNameTag < Liquid::Tag
    def initialize(tag_name, something_bogus, tokens)
      super
    end
    
    def render(context)
      full_url = context.environments.first['page']['url']
      full_url.split('/')[-1]
    end
  end
end

Liquid::Template.register_tag('filename', Jekyll::FileNameTag)
