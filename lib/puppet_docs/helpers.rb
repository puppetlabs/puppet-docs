module PuppetDocs
  module Helpers

    def ticket(n, text = nil, project = 'puppet')
      url = "http://projects.puppetlabs.com/projects/#{project}/tickets/#{n}"
      inner = text ? text : "Ticket ##{n}"
      %{<a href="#{url}">#{inner}</a>}
    end

    #  be used inside markdown.erb files.
    def md_child_list(subdir_names = 'types')
      list = page.parent.children.map do |e|
        if e != page
          if e.to_s =~ /markdown$/
            md_link(e.basename('.markdown'))
          elsif e.directory?
            md_link(e.basename, e.basename + '/') + " #{subdir_names}"

          end
        end
      end
      list.map { |item| "* #{item}" }.join("\n")
    end

    def md_link(text, url = text + '.html')
      "[#{text}](#{url})"
    end

  end
end
