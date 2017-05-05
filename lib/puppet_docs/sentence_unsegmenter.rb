#!/usr/bin/env ruby

# > sentence_unsegmenter.rb ./file1.html ./file2.html ./file3.html

# Sentence unsegmenter -- collapses a mangled structure like:
# <div class="real-paragraph">
#    <p class="temp-sentence"> ... </p>
#    <p class="temp-sentence"> ... </p>
# </div>
# ... into a normal <p> ... </p> element.

# This script expects any number of HTML fragment files as its argument(s). It
# will un-mangle the content and update it in-place, destroying the previous
# content of the files.

require 'nokogiri'

def unsegment_paragraphs(text)
  parsed = Nokogiri::HTML::DocumentFragment.parse(text)

  all_sentences = parsed.css('p.temp-sentence')
  all_real_paragraphs = parsed.css('div.real-paragraph')

  # break internal bubbles
  all_sentences.each do |sentence|
    sentence.replace(sentence.inner_html)
  end

  # transform into paragraph
  all_real_paragraphs.each do |graf|
    graf.replace( '<p>' << graf.inner_html << '</p>' )
  end

  parsed.to_html
end

ARGV.each do |filename|
  full_path = File.expand_path(filename)
  print "Un-mangling #{full_path}... "
  mangled_html = unsegment_paragraphs( File.read(full_path, encoding: 'utf-8') )
  File.open(full_path, 'w') do |f|
    f.write(mangled_html)
  end
  print " done.\n"
end

