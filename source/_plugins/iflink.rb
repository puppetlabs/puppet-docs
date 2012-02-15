module Jekyll
  class IfLinkTag < Liquid::Tag
		def initialize(tag_name, args, tokens)
			super
			if args =~ /"(.+?)",\s*"(.+?)"/
			  @linktext = $1
			  @linkdestination = $2
      else
        raise SyntaxError.new("Syntax Error in 'highlight' - Valid syntax: highlight <lang> [linenos]")
      end
		end
    
		def render(context)
      pageurl = context.environments.first['page']['url']
      pagedir = pageurl.split('/')[0..-2].join('/') + '/'
      linkpath = @linkdestination.split(/:\/\/[^\/]*/).last # take off any protocol or hostname
      absolutelinkpath = linkpath.sub(/^\.\//, pagedir) # so we can compare apples to apples -- note that if you use ../ in here, you probably won't get a very useful final link.
      
      # Debugging code, because I don't trust my memory enough to delete it:
      # welp = pageurl == absolutelinkpath
      # "<p>Page url: #{pageurl}</p><p>page dir: #{pagedir}</p>       <ul><li><strong>text:</strong> #{@linktext}</li><li><strong>destination:</strong> #{@linkdestination}</li><li><strong>absolute destination:</strong> #{absolutelinkpath}</li><li><strong>Are we on this page?:</strong> #{welp.to_s}</li></ul>"
      
      if pageurl == absolutelinkpath
        finaltext = %Q{<span class="currentpage">#{@linktext}</span>}
      else
        finaltext = %Q{<a href="#{@linkdestination}">#{@linktext}</a>}
      end

      finaltext
    end  
  
  end
end

Liquid::Template.register_tag('iflink', Jekyll::IfLinkTag)
