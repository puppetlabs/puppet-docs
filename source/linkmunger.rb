#!/usr/bin/env ruby
# Script takes a path to the folder acting as site root as argument, or else
# assumes it should treat the cwd as the site root.

require 'pathname'

def munge_links(html, page_url) # page_url must be a Pathname object, and be absolute, where / is the site root (not the system root)
  html.gsub( Regexp.new( %q{((href|src)=['"])(/|/[^/][^'"]*)(['"])} ) ) {|match|
    attribute_and_quote = $1
    # just_href_or_src = $2
    absolute_path = $3
    closing_quote = $4
    pagedir = page_url.dirname

    relative_path = Pathname.new(absolute_path).relative_path_from(pagedir)

    attribute_and_quote + relative_path.to_s + closing_quote
  }
end

site_root = Pathname.new('/')
document_root = Pathname.new( File.expand_path( ARGV.shift || Dir.pwd ) )
all_html_files = Pathname.glob( document_root + "**/*.html" ) # array of absolute Pathname objects

all_html_files.each do |page_file|
  page_url = site_root + page_file.relative_path_from(document_root)
  puts "Processing: #{page_url.to_s}"
  content = page_file.read
  page_file.open('w') {|f|
    f.print( munge_links(content, page_url) )
  }
end
