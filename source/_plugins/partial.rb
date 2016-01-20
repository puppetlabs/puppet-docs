# This is mostly a copy of Jekyll 3's built-in "include" tag, except it can grab
# files from anywhere; it isn't limited to the _includes dir like "include," or
# to a subdirectory of the current dir like "include_relative".

# Basic usage:
# {% partial ./repeated_text.markdown %}
# {% partial /puppetdb/latest/terminus.md %}

# Usage with local variables:
# {% partial _test_partial.md var1 = "First value!" var2='Second value!' %}
# Text of the corresponding fragment:
# * List item. Var 1 is {{ include.var1 }} and var2 is {{include.var2}}. var_3 is {{include.var_3}}

# Notes:
# * We use the same "include.var" namespace as the normal j3 include tag (to
#   make migration easier).
# * Omitted variables will render as empty strings.
# * Spaces and quoting are fairly generous.
# * If you don't put the value in quotation marks, it will be treated as a
#   variable reference (like page.title) instead.

# Security: By my understanding, Jekyll justifies its prissiness about the
# _includes dir as security concerns, but I'm pretty sure my implementation
# doesn't allow anyone to escape the source/ directory. If you try it with an
# absolute path (/Users/nick/.puppet/ssl/private_keys/magpie.lan.pem), it'll
# have the first slash removed and the source dir prepended to it, keeping it
# within source. If you try ascending a whole bunch
# (../../../../../.puppet/ssl/private_keys/magpie.lan.pem), the Pathname class
# will make it dead-end at "/" when we add it to the cwd to create
# absolute_url... and then we prepend the source dir to re-imprison it.

# Also, don't nest partials. It'll almost certainly work, but it sounds like a
# recipe for pain.  -NF

module Jekyll

  class PartialTagError < StandardError
    attr_accessor :path

    def initialize(msg, path)
      super(msg)
      @path = path
    end
  end

  class PartialTag < Liquid::Tag
    require 'pathname'

    VALID_SYNTAX = /([\w-]+)\s*=\s*(?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w\.-]+))/
    VARIABLE_SYNTAX = /(?<variable>[^{]*\{\{\s*(?<name>[\w\-\.]+)\s*(\|.*)?\}\}[^\s}]*)(?<params>.*)/


    def initialize(tag_name, markup, tokens)
      super
      matched = markup.strip.match(VARIABLE_SYNTAX)
      if matched
        @file = matched['variable'].strip
        @params = matched['params'].strip
      else
        @file, @params = markup.strip.split(' ', 2);
      end
      validate_params if @params
      @tag_name = tag_name
    end

    def syntax_example
      "{% #{@tag_name} file.ext param='value' param2='value' %}"
    end

    def parse_params(context)
      params = {}
      markup = @params

      while match = VALID_SYNTAX.match(markup) do
        markup = markup[match.end(0)..-1]

        value = if match[2]
          match[2].gsub(/\\"/, '"')
        elsif match[3]
          match[3].gsub(/\\'/, "'")
        elsif match[4]
          context[match[4]]
        end

        params[match[1]] = value
      end
      params
    end

    def validate_params
      full_valid_syntax = Regexp.compile('\A\s*(?:' + VALID_SYNTAX.to_s + '(?=\s|\z)\s*)*\z')
      unless @params =~ full_valid_syntax
        raise ArgumentError.new <<-eos
Invalid syntax for #{@tag_name} tag:

  #{@params}

Valid syntax:

  #{syntax_example}

eos
      end
    end

    # Render the variable if required -- NF: this is used if you store the file name in a variable, I think.
    def render_variable(context)
      if @file.match(VARIABLE_SYNTAX)
        partial = context.registers[:site].liquid_renderer.file("(variable)").parse(@file)
        partial.render!(context)
      end
    end

    def render(context)
      site = context.registers[:site]

      file = render_variable(context) || @file

      requested_path = Pathname.new(file)
      cwd            = Pathname.new(context.environments.first["page"]["url"]).parent
      sourcedir      = Pathname.new(context.registers[:site].source)
      root           = Pathname.new('/')

      absolute_url = cwd + requested_path # if it's already absolute, abs1 + abs2 = abs2.
      real_file = sourcedir + absolute_url.relative_path_from(root)

      # Add partial to dependency tree
      if context.registers[:page] and context.registers[:page].has_key? "path"
        site.regenerator.add_dependency(
          site.in_source_dir(context.registers[:page]["path"]),
          real_file.to_s
        )
      end


#       source = real_file.read
#       partial = Liquid::Template.parse(source)
#       context.stack do
#         partial.render(context)
#       end

      begin
        partial = site.liquid_renderer.file(real_file.to_s).parse(real_file.read)

        context.stack do
          context['include'] = parse_params(context) if @params
          partial.render!(context)
        end
      rescue => e
        raise PartialTagError.new e.message, real_file.to_s
      end


    end
  end

end

Liquid::Template.register_tag('partial', Jekyll::PartialTag)
