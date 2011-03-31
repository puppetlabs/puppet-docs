# Written by Nick Fagerlund.
# Insert a git revision from the docs repo into a document. Meant for
# tagging releases so people can tell whether a given issue seen on the
# compiled site/pdf still applies.

# Usage: {% gitrevision %} (for HEAD) or {% gitrevision 'arbitrary git treeish' %}

require 'jekyll'
class Gitrevision < Liquid::Tag
  def initialize(tag_name, treeish, tokens)
    super
    @treeish = treeish == '' ? 'HEAD' : treeish
  end
  
  def render(context)
    Dir.chdir(context.registers[:site].source) do
      %x(git rev-parse #{@treeish}).strip
    end
  end
  
end

Liquid::Template.register_tag('gitrevision', Gitrevision)