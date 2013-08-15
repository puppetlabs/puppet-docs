#!/usr/bin/env ruby

# This file should go in the ~/Application Support/BBEdit/Preview Filters directory. It will allow you to render Markdown files with the Kramdown filter in preview windows -- just use the drop-down at the top of the window.

# You may need to run `sudo gem install kramdown` before this will work.

require 'kramdown'

$content = ARGF.read

puts Kramdown::Document.new($content).to_html
