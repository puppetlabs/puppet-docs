module PuppetDocs
  module Helpers

    def ticket(n, text = nil, project = 'puppet')
      url = "http://projects.reductivelabs.com/projects/#{project}/tickets/#{n}"
      inner = text ? text : "Ticket ##{n}"
      %{<a href="#{url}">#{inner}</a>}
    end

  end
end
