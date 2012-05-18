# Written by Nick Fagerlund.
# This filter was a terrible idea. You feed page.url to it, and it spits out the first element of the path. Currently the only use for it is conditionally swapping in the MCollective sidebar nav; it can be deleted as soon as we refactor the mco pages to use the new layout and the page.nav variable.

require 'jekyll'

module URLRootFilter
  def urlroot(input)
    input.split('/')[1]
  end
end
Liquid::Template.register_filter(URLRootFilter)
