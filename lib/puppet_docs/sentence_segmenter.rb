#!/usr/bin/env ruby

# > sentence_segmenter.rb ./file1.html ./file2.html ./file3.html

# Sentence segmenter -- splits <p> elements into something like
# <div class="real-paragraph">
#    <p class="temp-sentence"> ... </p>
#    <p class="temp-sentence"> ... </p>
# </div>

# This script expects any number of HTML fragment files as its argument(s). It
# will mangle the content and update it in-place, destroying the previous
# content of the files.

require 'nokogiri'
require 'punkt-segmenter'

@tokenizer = nil

def call_punkt_segmenter(text)
  @tokenizer.sentences_from_text(text, :output => :sentences_text)
end

def segment_on_sentences(text)
  parsed = Nokogiri::HTML::DocumentFragment.parse(text)
  @tokenizer = Punkt::SentenceTokenizer.new(text)

  all_paragraphs = parsed.css('p')

  all_paragraphs.each do |graf|
    sentences = call_punkt_segmenter(graf.inner_html)
    new_div = '<div class="real-paragraph"> <p class="temp-sentence">' << sentences.join('</p> <p class="temp-sentence">') << '</p></div>'
    graf.replace(new_div)
  end

  parsed.to_html
end

ARGV.each do |filename|
  full_path = File.expand_path(filename)
  print "Mangling #{full_path}... "
  mangled_html = segment_on_sentences( File.read(full_path, encoding: 'utf-8') )
  File.open(full_path, 'w') do |f|
    f.write(mangled_html)
  end
  print " done.\n"
end


