require 'rubygems'

require 'set'
require 'pathname'

%w(maruku nokogiri erubis versionomy).each do |dep|
  begin
    require dep
  rescue LoadError
    abort "Could not require '#{dep}'.\nRun `rake install:#{dep}` (or `rake install`)"
  end
end

module PuppetDocs

  def self.root
    @root ||= Pathname.new(File.expand_path(__FILE__)).parent + '..'
  end

  autoload :Generator,         "puppet_docs/generator"
  autoload :Reference,         "puppet_docs/reference"
  autoload :Helpers,           "puppet_docs/helpers"
  autoload :Levenshtein,       "puppet_docs/levenshtein"
  autoload :Snippet,           "puppet_docs/snippet"
  autoload :View,              "puppet_docs/view"
  autoload :StringExt,         "puppet_docs/string_ext"
  
end

class String
  include PuppetDocs::StringExt
end


