# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with this
# work for additional information regarding copyright ownership.  The ASF
# licenses this file to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations under
# the License.

require 'jekyll'

module SinglePagifyLinksFilter
  def singlepagifylinks(input, url)
    # Receive the URL, make an ID prefix.
    id_prefix = url.gsub(/[\/\.]/, '-')
    path_array = url.split(/\//)
    # First, we need to make all the header element IDs unique, which we can do by just prefixing them with a unique ID for this HTML file. (We were passed this ID prefix as an argument to the filter call.) 
    # Actually, we need to catch lis (they're used in footnotes) as well as h\ds, because if we don't do that, we'll have to account for more types of link case than we want. This is harder than just diddling IDs for every element, because some of those are used for styling. we need to only touch the IDs that the stylesheet couldn't be aware of. 
    # We SHOULDN'T have to catch the divs that I'm manually linking to, because they are happening outside this filter. But those ARE going to be another link class, because we'll need to reach them pretty often and those links don't have an anchor attached. 
    input.gsub!(/<(h\d|li|sup) id="([^"]+)">/, %Q{<\\1 id="#{id_prefix}-\\2">})
    # Great, any links from outside this file will now be redirected to the proper unique IDs. Next, we need to make sure our outbound links are actually going to the correct place. We'll need to: 
    # * change ones that are internal to this file to point to the right place
    # * Change ones pointing to other files without a positional anchor to point to the divs I made in default.html
    # * Change ones pointing to positions in other files to point to the right place. 
    
    input.gsub!(/<a href="([^"]+)"( re.="footnote")?>/){ |match|
      href = $1
      if $2
        footnotish = $2
      else
        footnotish = ''
      end
      case href
        when /^#/
          # internal to this page. we'll do a gsub to take care of the # at the same time, but to be honest this is kind of brittle and depends on kramdown never putting a / or a . or a literal # in any of the header or footnote IDs. But eh, I feel like it's probably a safe assumption. 
          newhref = id_prefix + href.gsub(/[\/\.#]/, '-')
          %Q{<a href="##{newhref}"#{footnotish}>}
          # We have an extra requirement to preserve the footnote extras if it's a natively internal link.
        when /^(http:\/\/docs\.puppetlabs\.com\/|\/)/
          # complete path, easy. And we can treat anchors the same way as slashes and periods, because of the way we constructed the IDs!
          newhref = href.split('.com')[-1].gsub(/\/$/, '-index-html').gsub(/[\/\.#]/, '-')
          # Oh and there's one case I'm not accounting for with that pair of chained gsubs, which are links that go places like ../#learning-puppet, reason being that you just shouldn't make those. 
          %Q{<a href="##{newhref}">}
        when /^\.\//
          # Relative to our current path. Prepend the entire path except for our own filename.
          path_from_root = path_array.length > 2 ? '-' + path_array[1 .. -2].join('-') : ''
          # That last bit is necessary to have links from /index.html to ./learning/ral.html or whatever not EXPLODE. 
          newhref = path_from_root + href.gsub(/^\./, '').gsub(/\/$/, '-index-html').gsub(/[\/\.#]/, '-')
          # This looks like an indexing error and is worth explaining. Basically I wanted to do path_array[0..-2].join('-') and be done with it, but if our current file is in the root path, that subarray is actually just a string and the join won't work. So I do the first join manually just in case. Sorry. :/
          %Q{<a href="##{newhref}">}
        when /^\.\.\//
          # Relative to the path above our current path. Very similar to the last one. 
          newhref = '-' + path_array[1 .. -3].join('-') + href.gsub(/^\.\./, '').gsub(/\/$/, '-index-html').gsub(/[\/\.#]/, '-')
          %Q{<a href="##{newhref}">}
        else
          # It's probably an external link, so just leave it the hell alone. 
          %Q{<a href="#{href}">}
      end
    }
    
    input
  end
end
Liquid::Template.register_filter(SinglePagifyLinksFilter)
