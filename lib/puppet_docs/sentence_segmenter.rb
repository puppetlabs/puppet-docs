require 'nokogiri'
require 'punkt-segmenter'



# Sentence segmenter -- splits <p> elements into something like
# <div class="real-paragraph">
#    <p class="temp-sentence"> ... </p>
#    <p class="temp-sentence"> ... </p>
# </div>

# The mangle and unmangle methods expect HTML fragment files, output by the
# build process using the alternate fragment template. They transform the
# content and update it in-place, destroying the previous content of the files.

module PuppetDocs
  module SentenceSegmenter

    def self.segment_on_sentences(text)
      parsed = Nokogiri::HTML::DocumentFragment.parse(text)
      tokenizer = Punkt::SentenceTokenizer.new(text)

      all_paragraphs = parsed.css('p')

      all_paragraphs.each do |graf|
        sentences = tokenizer.sentences_from_text(graf.inner_html, :output => :sentences_text)
        new_div = '<div class="real-paragraph"> <p class="temp-sentence">' << sentences.join('</p> <p class="temp-sentence">') << '</p></div>'
        graf.replace(new_div)
      end

      parsed.to_html
    end

    def self.mangle_file(filename)
      full_path = File.expand_path(filename)
      print "Mangling #{full_path}... "
      mangled_html = segment_on_sentences( File.read(full_path, encoding: 'utf-8') )
      File.open(full_path, 'w') do |f|
        f.write(mangled_html)
      end
      print " done.\n"
    end

    def self.unsegment_paragraphs(text)
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

      # build yaml frontmatter by subbing in title from div.title
      title_div = parsed.at_css('div.title')
      title = title_div.content
      frontmatter = %Q{---
title: "#{title}"
---

}
      title_div.remove

      frontmatter + parsed.to_html
    end

    def self.unmangle_file(filename)
      full_path = File.expand_path(filename)
      print "Un-mangling #{full_path}... "
      fixed_html = unsegment_paragraphs( File.read(full_path, encoding: 'utf-8') )
      File.open(full_path, 'w') do |f|
        f.write(fixed_html)
      end
      print " done.\n"
    end


  end
end

