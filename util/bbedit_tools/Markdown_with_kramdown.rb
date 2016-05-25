#!/usr/bin/env ruby

# This file should go in one of the following directories:
#   * ~/Library/Application Support/BBEdit/Preview Filters
#   * ~/Dropbox/Application Support/BBEdit/Preview Filters
# It lets you render Markdown files with the Kramdown filter in preview windows
# -- just use the drop-down at the top of the window.

# You may need to run `sudo gem install kramdown` before this will work.

# Note that kramdown has to be installed in the SYSTEM gem path, not the rbenv
# one! Rbenv works great in the terminal, but not in GUI apps that don't source
# your bash profile before trying to execute scripts (e.g. bbedit).
#
# There are two ways to do this: either do `sudo /usr/bin/gem install kramdown`
# directly, or change rbenv back to "system" temporarily and then install
# kramdown.
#
# Actually there's a third way, as well: You can edit /etc/launchd.conf and add a line like:
# `setenv GEM_PATH <first rbenv gem path>:<second rbenv gem path>:<system gem path>`
# ...and then restart your computer. This will let your GUI apps load gems from
# rbenv. DON'T ACTUALLY DO THIS, though. You'll forget you set environment
# variables in that file, and then they'll eventually fall out of date and break
# something else, and you'll be pulling your hair out trying to figure out where
# these ghost variables are coming from.

require 'rubygems'
require 'kramdown'

ARGF.set_encoding('utf-8')
$content = ARGF.read
if $content =~ /\A---$/
  require 'yaml'
  (_blank, yaml_frontmatter, $content) = $content.split(/^---$/, 3)
  metadata = YAML.load("---\n" + yaml_frontmatter)
  lil_table = "<table>\n" + metadata.map {|k,v| "<tr> <td>#{k}</td> <td>#{v}</td> </tr>"}.join("\n") + "\n</table>\n"
  puts lil_table
end

puts Kramdown::Document.new($content, {input: "GFM", hard_wrap: false}).to_html
