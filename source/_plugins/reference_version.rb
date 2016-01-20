# NF again. This is a stupid little one-trick pony, but unfortunately it was the quickest way to get what I wanted.

module Jekyll
  class ReferenceVersionTag < Liquid::Tag
		def initialize(tag_name, args, tokens)
			super
		end

		def render(context)
      pageurl = context.environments.first['page']['url']
      # "/references/3.0.latest/type.html".split('/', -1) -> ["", "references", "3.0.latest", "type.html"]
      pageurl.split('/', -1)[2]
    end

  end
end

Liquid::Template.register_tag('reference_version', Jekyll::ReferenceVersionTag)
