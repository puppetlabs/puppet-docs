require 'pathname'
require 'byebug'

# {% change_baseurl url old_baseurl new_baseurl %}
# Arguments are space-separated. Literal strings must be quoted;
# otherwise we assume the args are variables.
module Jekyll
  class ChangeBaseurl < Liquid::Tag
    def initialize(tag_name, args_string, tokens)
      super
      @arg_regex = /\s*(?:#{Liquid::VariableSignature}+|"[^"]+"|'[^']')\s*/
      @var_regex = /\A#{Liquid::VariableSignature}+\Z/
      @args = args_string.scan(@arg_regex).map{|a|a.strip}
      if @args.length != 3
        @error = "Tag error: Gave #{args.length} arguments; change_baseurl tag requires url, old_baseurl, new_baseurl."
      end
    end

    def render(context)
      (@url, @old_baseurl, @new_baseurl) = @args.map{|arg|
        if arg =~ @var_regex
          Liquid::Variable.new(arg).render(context)
        else
          arg.sub(/\A['"]/, '').sub(/['"]\Z/, '')
        end
      }.map{|path| Pathname.new(path)}


      relative_path = @url.relative_path_from(@old_baseurl)
      new_path = @new_baseurl + relative_path
      new_path.to_s
    end
  end
end

Liquid::Template.register_tag('change_baseurl', Jekyll::ChangeBaseurl)
