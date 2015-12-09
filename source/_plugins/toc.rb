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
    toc = []
    sublist_stack = []
    input.scan(%r{
      <(h # 0: Enclosing group with the whole element name
        ([23]) # 1: Header level
      )
      (?:
        >|\s+(.*?)> # 2: Either nil or an attribute string which probably includes id="blah"; the group makes a capture even if the alternator keeps matching from reaching it.
      )
      (.*?) # 3: Header text, potentially including an <em> or <code> element
      </\1\s*> # Closing tag
    }imx).each { |entry|
      hlevel = entry[1].to_i
      if entry[2].class == String
        id = entry[2][/id\s*=\s*(['"])(.*?)\1/, 2]
      else # Don't try to call [] on nil.
        id = ''
      end
      text = entry[3].gsub(/<[^>]+>/m, '').strip # Get rid of any span-level tags inside the header text, and strip trailing whitespace.
      if hdepth == 0
        sublist_stack.push(toc) # Prime the pump. This has to be exclusive of the next elsif.
      elsif hdepth < hlevel
        sublist_stack.last.last['sublist'] = []
        sublist_stack.push(sublist_stack.last.last['sublist']) # we just now entered a deeper header level.
      elsif hdepth > hlevel
        sublist_stack.pop unless sublist_stack.last.object_id == toc.object_id # Ascend to a shallower header level. The unless protects us from the case where an H3 appeared before the first H2.
      # else we're at the same level as last time and don't need to change course.
      end
      sublist_stack.last.push(
        {
          'text' => text,
          'id' => id,
          'hlevel' => hlevel
        }
      )
      hdepth = hlevel # Set the current depth.
    }
    print_toc_sublist(toc)
  end
  def print_toc_sublist(ary)
    return '' if ary == nil # Most common case.
    sublist_string = ''
    sublist_string << %{\n<ol class="toc">\n}
    ary.each {|header|
      sublist_string << %{#{" " * header['hlevel'].to_i}<li class="toc-lv#{header['hlevel']}"><a href="##{header['id']}">#{header['text']}</a>}
      sublist_string << print_toc_sublist(header['sublist'])
      sublist_string << "</li>\n"
    }

    sublist_string << "</ol>"
    sublist_string
  end

end
Liquid::Template.register_filter(TocFilter)
