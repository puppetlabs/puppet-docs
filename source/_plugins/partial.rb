# This is a copy of the built-in "include" tag, except it can grab files from anywhere.
# {% partial ./repeated_text.markdown %}
# {% partial /puppetdb/latest/terminus.md %}

# Security: AFAICT this makes it impossible to escape the source/ directory, so
# this should be pretty safe to use. If you try it with an absolute path
# (/Users/nick/.puppet/ssl/private_keys/magpie.lan.pem), it'll have the first
# slash removed and the source dir prepended to it, keeping it within source. If
# you try ascending a whole bunch
# (../../../../../.puppet/ssl/private_keys/magpie.lan.pem), the Pathname class
# will make it dead-end at "/" when we add it to the cwd to create
# absolute_url... and then we'll prepend the source dir to re-imprison it.

# Also, don't nest partials, I dunno what'll happen.  -NF

module Jekyll

  class PartialTag < Liquid::Tag
    require 'pathname'

    def initialize(tag_name, file, tokens)
      super
      @file = file.strip
    end

    def render(context)

      requested_path = Pathname.new(@file)
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

Liquid::Template.register_tag('partial', Jekyll::PartialTag)
