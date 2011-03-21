require 'jekyll'

module URLRootFilter
  def urlroot(input)
    input.split('/')[1]
  end
end
Liquid::Template.register_filter(URLRootFilter)
