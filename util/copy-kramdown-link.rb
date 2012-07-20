#!/usr/bin/env ruby

# Put this in BBEdit's scripts folder. 
# Select the text of a Markdown header in one of our source files, and run the filter. It will leave the selection alone, but will copy a link to the anchor, including the post-conversion (*.html) filename, to the clipboard. 
# This could probably be easily munged to work with other editors, but is for BBEdit because that's what Nick and Fred use. 
# The generate_id function is ripped directly out of the kramdown source code, minus the part where it keeps track of duplicates and disambiguates them with numbers. So it won't work with headers that are duped within a page, but you should only be using dupe headers if you don't plan to link to them anyway. 

selection = %x{osascript -e 'tell app "BBEdit" to get selection as text'}
filename = ENV['BB_DOC_NAME']

def generate_id(str)
  gen_id = str.gsub(/^[^a-zA-Z]+/, '')
  gen_id.tr!('^a-zA-Z0-9 -', '')
  gen_id.tr!(' ', '-')
  gen_id.downcase!
  gen_id
end

converted_filename = filename.sub(/\.(markdown|md|textile)$/, '.html')
full_link = converted_filename + '#' + generate_id(selection)
IO.popen('pbcopy', 'w').print full_link
