# Written by Nick Fagerlund
# Insert a list of recent commits to the puppet-docs project, linked to each
# respective github page.

# Usage: {% recent_commits %} or {% recent_commits 15 %}

require 'jekyll'
class RecentCommits < Liquid::Tag
  def initialize(tag_name, limit, tokens)
    super
    @limit = (limit == '') ? 10 : limit
  end

  def render(context)
    Dir.chdir(context.registers[:site].source) do
      htmlfragment = ''
      htmlfragment << "<h3>Recent commits to the puppet-docs repo:</h3>\n<ul>\n"
      commits = %x(git log --oneline --no-merges -n #{@limit} --no-abbrev-commit)
      commits.each_line do |line|
        fields = line.split(' ', 2)
        sha = fields[0]
        message = fields[1].chomp.gsub(/[<>]/, '')
        htmlfragment << %Q{<li><a href="https://github.com/puppetlabs/puppet-docs/commit/#{sha}">#{message}</a></li>\n}
      end
      htmlfragment << "</ul>\n"
      htmlfragment << %q{<p><a href="https://github.com/puppetlabs/puppet-docs/commits/master">(More)</a> &mdash; <a href="https://github.com/puppetlabs/puppet-docs/commits/master.atom">(Feed)</a></p>}
    end
  end

end

Liquid::Template.register_tag('recent_commits', RecentCommits)