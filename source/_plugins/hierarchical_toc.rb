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

module TocFilter
  def toc(input)
    hdepth = 0
    lists_outstanding = []
    input.scan(%r{
      <(h # 0: Enclosing group with the whole element name
        ([23]) # 1: Header level
      )
      (?:
        >|\s+(.*?)> # 2: Empty or an attribute string which probably includes id="blah;" the group makes a capture even if the alternator keeps matching from reaching it.
      )
      (.*?) # 3: Header text, potentially including an <em> or <code> element
      </\1\s*> # Closing tag
    }imx).inject('') { |toc, entry|
      hlevel = entry[1].to_i
      id = entry[2][/^id\s*=\s*(['"])(.*)\1$/, 2]
      title = entry[3].gsub(/<[^>]+>/m, '').strip # Get rid of any span-level tags inside the header text, and strip trailing whitespace.
      if hdepth < hlevel
        toc << %{<ol class="toc">}  # If we just now entered a deeper header level, start a new sublist. This case also covers the beginning of the TOC, since we're increasing from 0.
        lists_outstanding.push(1) # Keep track of sublists.
      elsif hdepth > hlevel
        toc << %{</ol>} # If we just ascended to a shallower header level, end the previous sublist.
        lists_outstanding.pop # keep track of sublists
      end
      toc << %{<li class="toc-lv#{hlevel}"><a href="##{id}">#{title}</a></li>} # Make an element for this header. We can style these li elements by header level in CSS now. 
      hdepth = hlevel # Set the current depth.
      toc
    } << ("</ol>\r" * lists_outstanding.length) # Note that this will barf if the page contains an h3 before any h2s appear.
  end
end
Liquid::Template.register_filter(TocFilter)
